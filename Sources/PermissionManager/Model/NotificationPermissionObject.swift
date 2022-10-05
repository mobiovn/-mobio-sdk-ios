//
//  NotificationPermissionObject.swift
//  PermissionApp
//
//  Created by Sun on 08/09/2022.
//

import NotificationCenter

@available(iOSApplicationExtension, unavailable)
class NotificationPermissionObject: PermissionObject {
    
    var permissionHandler: VoidHandler?
    var name: String = "Notification"
    var summany: String = "Allow to show permission alert"
    var emptyImage: String = "notification_empty"
    var fullImage: String = "notification_full"
    
    let center = UNUserNotificationCenter.current()
    
    func checkStatus(handler: @escaping (PermissionStatus) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    handler(.allowed)
                } else {
                    handler(.notAllow)
                }
            }
        }
    }
    
    func requestPermission() {
        registerForPushNotifications()
    }
    
    func registerForPushNotifications() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (granted, error) in
            guard let self = self else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        center.getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.setupNotificationSetting(settings: settings)
            }
        }
    }
    
    func setupNotificationSetting(settings: UNNotificationSettings) {
        if settings.authorizationStatus == .authorized {
            UIApplication.shared.registerForRemoteNotifications()
            permissionHandler?(.allowed)
        } else {
            permissionHandler?(.notAllow)
        }
    }
}
