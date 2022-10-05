//
//  AppDelegate.swift
//  ExampleProject
//
//  Created by Sun on 21/12/2021.
//

import UIKit
import MobioSDK

@main
class AppDelegate: UIResponder {

    var analytics = MobioSDK.shared
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let config = Configuration()
            .setupCode(code: "m-code")
            .setupSource(source: "m-source")
            .setupApi(baseUrlType: .test)
        analytics.bindConfig(config)
        analytics.registerForPushNotifications()
        toMain()
        return true
    }
    
    private func toMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        guard let window = window else { return }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        analytics.send(deviceToken: token)
    }
}
