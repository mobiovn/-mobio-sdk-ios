//
//  RatingViewController.swift
//  RatingApp
//
//  Created by Sun on 19/08/2022.
//

import UIKit
import UserNotificationsUI

final class RatingViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var ratingStackView: UIStackView!

    
    // MARK: - Property
    var data: NotificationContentDataType!
    var ratingButtonArray = [UIButton]()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        downLoadData()
    }
    
    // MARK: - Data
    private func downLoadData() {
        guard let ratingData = data as? Rating else { return }
        downloadImage(from: ratingData.imageURL) { [weak self] data in
            guard let self = self else { return }
            self.imageView.image = UIImage(data: data)
        }
        let group = DispatchGroup()
        var emptyStar: UIImage?
        group.enter()
        downloadImage(from: ratingData.emptyStarURL) { data in
            emptyStar = UIImage(data: data, scale: 10)
            group.leave()
        }
        var fullStar: UIImage?
        group.enter()
        downloadImage(from: ratingData.fullStarURL) { data in
            fullStar = UIImage(data: data, scale: 10)
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.setupButtonArray(emptyStar: emptyStar, fullStar: fullStar)
        }
    }
    
    private func setupButtonArray(emptyStar: UIImage?, fullStar: UIImage?) {
        guard let ratingData = data as? Rating else { return }
        for index in 0..<ratingData.ratingNumber {
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(fullStar, for: .selected)
            button.tintColor = .clear
            button.tag = index
            button.addTarget(self, action: #selector(ratingAction(_:)), for: .touchUpInside)
            ratingButtonArray.append(button)
        }
        setupVoteStackView(with: ratingButtonArray)
    }
    
    private func setupVoteStackView(with ratingButtonArray: [UIButton]) {
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingButtonArray.forEach { button in
            ratingStackView.addArrangedSubview(button)
        }
    }
    
    func downloadImage(from urlString: String, complete: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    complete(data)
                }
            }
        }.resume()
    }
    
    // MARK: - Action
    @objc func ratingAction(_ sender: UIButton) {
        changeStateButton(button: sender)
    }
    
    private func changeStateButton(button: UIButton) {
        for index in 0...button.tag {
            let button = ratingButtonArray[index]
            changeStateToSelected(button)
        }
        for index in button.tag+1..<ratingButtonArray.count {
            let button = ratingButtonArray[index]
            changeStateToNormal(button)
        }
    }
    
    private func changeStateToNormal(_ button: UIButton) {
        button.isSelected = false
    }
    
    private func changeStateToSelected(_ button: UIButton) {
        button.isSelected = true
    }
}

extension RatingViewController: NotificationContentViewControllerType {
    
    func handleAction(response: UNNotificationResponse) -> UNNotificationContentExtensionResponseOption {
        return .dismiss
    }
    
    func configureUserNotificationsCenter() {
    }
}
