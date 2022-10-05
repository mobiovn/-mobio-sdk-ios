//
//  MobioRemoteNotification.swift
//  ExampleNotification
//
//  Created by Sun on 02/11/2021.
//

import UserNotifications
import UIKit

@available(iOSApplicationExtension, unavailable)
protocol MobioRemoteNotificationType {
    
    // MARK: - function
    func registerForPushNotifications()
    func notificationWillPresent(with notification: UNNotification, completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    func notificationDidReceive(with response: UNNotificationResponse)
}

@available(iOSApplicationExtension, unavailable)
final class MobioRemoteNotification: NSObject {
    
    // MARK: - Constant
    struct Constant {
        static let categoryIdentifier = "scheduleCategory"
    }
    
    enum ActionIdentifier: String {
        case schedule
    }
    
    // MARK: - Property
    let center = UNUserNotificationCenter.current()
    var viewModel: RemoteNotificationViewModel!
    let notificationRepository = NotificationRepository(api: HTTPClient.shared)
    
    override init() {
        super.init()
        setupNotificationAction()
    }
    
    private func setupNotificationAction() {
        let scheduleAction = UNNotificationAction(identifier: ActionIdentifier.schedule.rawValue, title: "Schedule", options: [.destructive])
        let actionCategory = UNNotificationCategory(identifier: Constant.categoryIdentifier, actions: [scheduleAction], intentIdentifiers: [], options: .customDismissAction)
        center.setNotificationCategories([actionCategory])
    }
    
    private func handleNotificationAction(actionIdentifier: ActionIdentifier?, content: UNNotificationContent) {
        switch actionIdentifier {
        case .schedule:
            scheduleRemoteNotification(content: content)
        case .none:
            break
        }
    }
    
    private func scheduleRemoteNotification(content: UNNotificationContent) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}

@available(iOSApplicationExtension, unavailable)
extension MobioRemoteNotification: MobioRemoteNotificationType {
    
    func registerForPushNotifications() {
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (granted, error) in
            guard let self = self else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        center.getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            self.setupNotificationSetting(settings: settings)
        }
    }
    
    func setupNotificationSetting(settings: UNNotificationSettings) {
        if settings.authorizationStatus == .authorized {
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            notificationRepository.sendNotificationData(permission: "denied", token: "")
        }
    }
    
    func notificationWillPresent(with notification: UNNotification, completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let request = notification.request
        let content = request.content
        guard let userInfo = content.userInfo as? [String : Any] else { return }
        DictionaryPrinter.printBeauty(with: userInfo)
        guard let remoteNotificationData = JSONManager.decode(RemoteNotificationData.self, from: userInfo) else { return }
        let state = UIApplication.shared.applicationState
        if state == .background  {
            if let popupData = remoteNotificationData.data {
                WebPopupStatusManager.pushDataStatusPopup(popupData: popupData, statusCase: .receive(.normal))
            }
            completionHandler([.alert, .badge, .sound])
        } else if state == .active || state == .inactive {
            if let popupData = remoteNotificationData.data {
                WebPopupStatusManager.pushDataStatusPopup(popupData: popupData, statusCase: .receive(.popup))
            }
            viewModel.decideShowPopup(remoteNotificationData: remoteNotificationData)
            if remoteNotificationData.alert?.contentType != "html" &&  remoteNotificationData.alert?.contentType != "popup" {
                completionHandler([.alert, .badge, .sound])
            }
        }
        MobioSDK.shared.configuration.setupCanSendDataBackToEnd(remoteNotificationData.alert?.status)
    }
    
    func notificationDidReceive(with response: UNNotificationResponse) {
        let notification = response.notification
        let request = notification.request
        let content = request.content
        guard let userInfo = content.userInfo as? [String : Any] else { return }
        guard let remoteNotificationData = JSONManager.decode(RemoteNotificationData.self, from: userInfo) else { return }
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive {
            viewModel.decideShowPopup(remoteNotificationData: remoteNotificationData)
        }
        handleNotificationAction(actionIdentifier: ActionIdentifier(rawValue: response.actionIdentifier), content: content)
    }
}

@available(iOSApplicationExtension, unavailable)
extension MobioRemoteNotification: BindableType { }

@available(iOSApplicationExtension, unavailable)
extension MobioRemoteNotification: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        notificationWillPresent(with: notification, completionHandler: completionHandler)
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        notificationDidReceive(with: response)
        completionHandler()
    }
}
