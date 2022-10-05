//
//  IOSLifecycleMonitor.swift
//
//  Created by LinhNobi on 27/08/2021.
//

import Foundation
import UIKit

@available(iOSApplicationExtension, unavailable)
class IOSLifecycleMonitor {
    
    @available(iOSApplicationExtension, unavailable)
    private var application = UIApplication.shared
    private var appNotifications = [UIApplication.didEnterBackgroundNotification,
                                    UIApplication.willEnterForegroundNotification,
                                    UIApplication.didFinishLaunchingNotification,
                                    UIApplication.didBecomeActiveNotification,
                                    UIApplication.willResignActiveNotification,
                                    UIApplication.didReceiveMemoryWarningNotification,
                                    UIApplication.willTerminateNotification,
                                    UIApplication.significantTimeChangeNotification,
                                    UIApplication.backgroundRefreshStatusDidChangeNotification]
    lazy var myLocalNotificaion = MyLocalNotification()
    private var event: Event!
    lazy var observerBackend = ObserverBackend()
    let viewModel = iOSLifecycleMonitorViewModel()
    let permissionManager = PermissionManager(listPermissionCase: [.notification])
    
    init() {
        setupObserverBackend()
    }
    
    @available(iOSApplicationExtension, unavailable)
    func setupListeners() {
        let notificationCenter = NotificationCenter.default
        for notification in appNotifications {
            notificationCenter.addObserver(self, selector: #selector(notificationResponse(notification:)), name: notification, object: application)
        }
    }
    
    @objc
    func notificationResponse(notification: NSNotification) {
        switch (notification.name) {
        case UIApplication.didFinishLaunchingNotification:
            viewModel.didFinishLaunching()
            permissionManager.checkStatusListPermission()
        case UIApplication.willTerminateNotification, UIApplication.didEnterBackgroundNotification:
            terminateAction()
            DBManager.shared.save()
        case UIApplication.willEnterForegroundNotification:
            permissionManager.reload()
        default:
            break
        }
    }
}

@available(iOSApplicationExtension, unavailable)
extension IOSLifecycleMonitor {
    
    private func terminateAction() {
        if event == nil {
            return
        }
        let pushArray = event.findDataPushArray()
        for index in 0..<pushArray.count {
            let push = pushArray[index]
            let notifData = push.notiResponse
            let notifContent = NotificationContent(title: notifData.title, body: notifData.content, pushID: push.nodeID)
            let timeInterval = TimeInterval(index * 5) + 1
            myLocalNotificaion.pushNotif(with: notifContent, after: timeInterval)
            observerBackend.pushRepository.pushIsShowed(push.nodeID)
        }
    }
    
    private func setupObserverBackend() {
        observerBackend.startListenEvent()
        observerBackend.passEvent = { [weak self] in
            guard let self = self else { return }
            self.event = $0
        }
    }
}
