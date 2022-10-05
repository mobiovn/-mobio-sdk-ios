//
//  SliderViewController.swift
//  
//
//  Created by Sun on 04/08/2022.
//

import UIKit
import UserNotificationsUI

class SliderViewController: UIViewController, NotificationContentViewControllerType {

    // MARK: - Outlet
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    // MARK: - Property
    var imageDataDictionary = [String: UIImage]()
    var currentIndex = 0
    let group = DispatchGroup()
    var data: NotificationContentDataType!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }
    
    // MARK: - View
    private func setupView() {
        let nib = UINib(nibName: ImageCell.nibName, bundle: AppInfo.mobioSDKBundle)
        collectionView.register(nib, forCellWithReuseIdentifier: ImageCell.nibName)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Data
    func getCurrentRow() -> Int {
        for cell in collectionView.visibleCells {
            if let row = collectionView.indexPath(for: cell)?.item {
                return row
            }
        }
        return 0
    }
    
    @objc func setupSlider() {
        scrollToItem(calculator: +)
    }
    
    func downloadAllImage() {
        guard let sliderData = data as? Slider else { return }
        sliderData.imageStringArray.forEach { urlString in
            downloadImage(from: urlString)
        }
    }
    
    func downloadImage(from urlString: String) {
        group.enter()
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data {
                let image = UIImage(data: data)
                self.imageDataDictionary[urlString] = image
                self.group.leave()
            }
        }.resume()
    }
    
    func setupDataWhenDownloadDone() {
        guard let sliderData = data as? Slider else { return }
        let timeStep = sliderData.timeStep ?? 2
        Timer.scheduledTimer(timeInterval: timeStep, target: self, selector: #selector(setupSlider), userInfo: nil, repeats: true)
        pageControl.numberOfPages = sliderData.imageStringArray.count
        collectionView.reloadData()
    }
    
    func setupData() {
        let activityIndicatorView = ActivityIndicatorView(frame: collectionView.bounds)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        downloadAllImage()
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.setupDataWhenDownloadDone()
            activityIndicatorView.stopAnimating()
        }
    }
    
    // MARK: - Action
    @IBAction func backAction(_ sender: Any) {
        scrollToItem(calculator: -)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        scrollToItem(calculator: +)
    }
    
    private func scrollToItem(calculator: (Int, Int) -> Int) {
        guard let sliderData = data as? Slider else { return }
        let maxCount = sliderData.imageStringArray.count
        var currentRow = getCurrentRow()
        currentRow = calculator(currentRow, 1)
        currentRow = currentRow % maxCount
        let toIndexPath = IndexPath(row: currentRow, section: 0)
        collectionView.scrollToItem(at: toIndexPath, at: .centeredVertically, animated: true)
    }
}

extension SliderViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.nibName, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        if imageDataDictionary.count != 0 {
            guard let sliderData = data as? Slider else { return UICollectionViewCell() }
            let imageStringItem = sliderData.imageStringArray[indexPath.row]
            let imageData = imageDataDictionary[imageStringItem]
            cell.setContent(image: imageData)
            return cell
        } else {
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageDataDictionary.count != 0 {
            guard let sliderData = data as? Slider else { return 3 }
            return sliderData.imageStringArray.count
        } else {
            return 3
        }
    }
}

extension SliderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        pageControl.currentPage = getCurrentRow()
    }
}

extension SliderViewController {
    
    enum NotificationActionIdentifier: String {
        case backAction
        case nextAction
    }
    
    func handleAction(response: UNNotificationResponse) -> UNNotificationContentExtensionResponseOption {
        switch response.actionIdentifier {
        case NotificationActionIdentifier.backAction.rawValue:
            backAction(self)
        case NotificationActionIdentifier.nextAction.rawValue:
            nextAction(self)
        default:
            break
        }
        return .doNotDismiss
    }
    
    func configureUserNotificationsCenter() {
        let backAction = UNNotificationAction(identifier: NotificationActionIdentifier.backAction.rawValue, title: "Back", options: [])
        let nextAction = UNNotificationAction(identifier: NotificationActionIdentifier.nextAction.rawValue, title: "Next", options: [])
        let tutorialCategory = UNNotificationCategory(identifier: "myNotificationCategory",
                                                      actions: [backAction, nextAction],
                                                      intentIdentifiers: [],
                                                      options: [.customDismissAction])
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([tutorialCategory])
    }
}
