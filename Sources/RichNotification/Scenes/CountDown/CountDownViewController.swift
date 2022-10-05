//
//  CountDownViewController.swift
//  MobioSDKSwift
//
//  Created by sun on 13/08/2022.
//

import UIKit
import UserNotificationsUI

final class CountDownViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var countDownLabel: UILabel!
    
    // MARK: - Property
    var nowTime = Date()
    var dateComponents: DateComponents!
    var data: NotificationContentDataType!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        showTime()
    }
    
    // MARK: - Data
    func setupData() {
        guard let countDownData = data as? CountDown else { return }
        titleLabel.text = countDownData.title
        bodyLabel.text = countDownData.body
        downloadImage(from: countDownData.imageURL)
    }
    
    func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    private func getTimeInfor(dateComponents: DateComponents) -> String {
        var sumary = ""
        let years = abs(dateComponents.year!)
        if 0 < years && years < 10 {
            sumary += "0\(years)"
            sumary += " years "
        }
        if years > 9 {
            sumary += "\(years)"
            sumary += " years "
        }
        let month = abs(dateComponents.month!)
        if 0 < month && month < 10 {
            sumary += "0\(month)"
            sumary += " month "
        }
        if month > 9 {
            sumary += "\(month)"
            sumary += " month "
        }
        let weeks = abs(dateComponents.weekOfMonth!)
        if weeks > 0 && weeks < 10 {
            sumary += "0\(weeks)"
            sumary += " weeks "
        }
        if weeks > 9 {
            sumary += "\(weeks)"
            sumary += " weeks "
        }
        let days = abs(dateComponents.day!)
        if 0 < days && days < 10 {
            sumary += "0\(days)"
            sumary += " days "
        }
        if days > 9 {
            sumary += "\(days)"
            sumary += " days "
        }
        let hours = abs(dateComponents.hour!)
        if 0 < hours && hours < 10 {
            sumary += "0\(hours)"
            sumary += " hours "
        }
        if hours > 9 {
            sumary += "\(hours)"
            sumary += " hours "
        }
        let min = abs(dateComponents.minute!)
        if 0 < min && min < 10 {
            sumary += "0\(min)"
            sumary += " min "
        }
        if min > 9 {
            sumary += "\(min)"
            sumary += " min "
        }
        let sec = abs(dateComponents.second!)
        if 0 == sec {
            sumary += "0 sec"
        }
        if 0 < sec && sec < 10 {
            sumary += "0\(sec)"
            sumary += " sec "
        }
        if sec > 9 {
            sumary += "\(sec)"
            sumary += " sec"
        }
        return sumary
    }
    
    func countTime(timer: Timer? = nil, countDownData: CountDown) {
        if nowTime.timeIntervalSince1970.rounded() < countDownData.endDate.timeIntervalSince1970 {
            nowTime = Date()
            dateComponents = Calendar.current.dateComponents([.weekOfMonth, .day , .hour, .minute, .second, .year, .month], from: nowTime, to: countDownData.endDate)
            let sumary = getTimeInfor(dateComponents: dateComponents)
            countDownLabel.text = sumary
        } else {
            countDownLabel.text = "0 sec"
            timer?.invalidate()
        }
    }
    
    func showTime() {
        guard let countDownData = data as? CountDown else { return }
        countTime(timer: nil, countDownData: countDownData)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.countTime(timer: timer, countDownData: countDownData)
        }
    }
}

extension CountDownViewController: NotificationContentViewControllerType {
    
    func handleAction(response: UNNotificationResponse) -> UNNotificationContentExtensionResponseOption {
        .dismiss
    }
    
    func configureUserNotificationsCenter() {
    }
}
