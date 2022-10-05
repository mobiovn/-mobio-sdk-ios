//
//  MobioSDK.swift
//  AppDemo
//
//  Created by LinhNobi on 25/08/2021.
//

import Foundation
import UserNotifications

@available(iOSApplicationExtension, unavailable)
@objcMembers open class MobioSDK: NSObject {
    
    // MARK: - Define
    struct Constant {
        static let version = "1.0"
    }
    public typealias Dictionary = [String : Any]
    
    // MARK: - Property
    public static let shared = MobioSDK()
    var iOSlife = IOSLifecycleMonitor()
    let trackingManager = TrackingManager()
    let screenSettingManager = ScreenSettingManager()
    let mobioRemoteNotification = MobioRemoteNotification()
    var apiRecallManager = APIRecallManager.shared
    let notificationRepository = NotificationRepository(api: HTTPClient.shared)
    let connectionManager = ConnectionManager.shared
    var configuration = Configuration()
    
    private override init() {
        super.init()
        iOSlife.setupListeners()
        setupRemoteNotification()
        apiRecallManager.setupInternetManager()
    }
    
    /// Setup configuration.
    ///
    /// In example.
    ///
    ///     let config = Configuration()
    ///     analytics.bindConfig(configuration: config)
    ///
    /// - Parameter configuration: configuration object.
    public func bindConfig(_ configuration: Configuration) {
        self.configuration = configuration
        self.configuration.delegate = self
    }
    
    private func setupRemoteNotification() {
        mobioRemoteNotification.registerForPushNotifications()
        let remoteNotificationViewModel = RemoteNotificationViewModel()
        mobioRemoteNotification.bindViewModel(to: remoteNotificationViewModel)
    }
    
    /// Send device token string to Mobio
    ///
    /// In example.
    ///
    ///     analytics.send(deviceToken: token)
    ///
    /// - Parameter deviceToken: The device token string.
    public func send(deviceToken: String) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (notificationSettings) in
            if notificationSettings.authorizationStatus == .authorized {
                self.notificationRepository.sendNotificationData(permission: "granted", token: deviceToken)
            }
        }
    }
    
    /// Listen deep link.
    ///
    /// In example.
    ///```
    /// func application(_ application: UIApplication,
    ///                 open url: URL,
    ///                 options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    ///    analytics.deeplink(with: url.host)
    ///    return false
    ///}
    ///```
    public func deeplink(with viewController: String?) {
        guard let viewController = viewController else { return }
        let navigator = Navigator(screenNameArray: [viewController], type: .goto)
        navigator.navigationAction()
    }
}

@available(iOSApplicationExtension, unavailable)
extension MobioSDK: MobioRemoteNotificationType {
    
    /// Register push notifications
    ///
    /// In example.
    ///
    ///     analytics.registerForPushNotifications()
    public func registerForPushNotifications() {
        mobioRemoteNotification.registerForPushNotifications()
    }
    
    /// Listen notification coming.
    ///
    /// In example.
    ///```
    ///public func userNotificationCenter(_ center: UNUserNotificationCenter,
    ///                                   willPresent notification: UNNotification,
    ///                                   withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    ///    analytics.notificationWillPresent(with: notification, completionHandler: completionHandler)
    ///}
    ///```
    public func notificationWillPresent(with notification: UNNotification, completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        mobioRemoteNotification.notificationWillPresent(with: notification, completionHandler: completionHandler)
    }
    
    /// Listen notification did tap.
    ///
    /// In example.
    ///```
    /// public func userNotificationCenter(_ center: UNUserNotificationCenter,
    ///                                       didReceive response: UNNotificationResponse,
    ///                                       withCompletionHandler completionHandler: @escaping () -> Void) {
    ///        analytics.notificationDidReceive(with: response)
    ///        completionHandler()
    ///}
    ///```
    public func notificationDidReceive(with response: UNNotificationResponse) {
        mobioRemoteNotification.notificationDidReceive(with: response)
    }
}

@available(iOSApplicationExtension, unavailable)
extension MobioSDK: ConfigurationDelegate {
    
    func trackableDidSet(value: Bool) {
        apiRecallManager.fetchFailApi()
    }
}
