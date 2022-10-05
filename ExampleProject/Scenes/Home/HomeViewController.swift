//
//  HomeViewController.swift
//  ExampleProject
//
//  Created by Sun on 21/12/2021.
//

import UIKit
import MobioSDK

final class HomeViewController: UIViewController {
    
    // MARK: - Property
    var analytics = MobioSDK.shared
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        analytics.screenSetting(title: "Home", controllerName: "HomeViewController", timeVisit: [3])
        addBehaviors([])
        analytics.screenSetting(title: "RechargeConfirm", controllerName: "FavoriteViewController", timeVisit: [3])
        analytics.screenSetting(title: "Recharge", controllerName: "CategoryViewController", timeVisit: [3])
        analytics.screenSetting(title: "SaveMoney", controllerName: "SaveMoneyViewController", timeVisit: [3])
    }
    
    // MARK: - Action
    @IBAction func gotoCategory(_ sender: Any) {
        let viewController = CategoryViewController.instantiate()
        present(viewController, animated: true)
    }
    @IBAction func gotoScrollScreen(_ sender: Any) {
        let accountScreen = AccountViewController()
        navigationController?.pushViewController(accountScreen, animated: true)
    }
    
    @IBAction func deeplinkAction(_ sender: Any) {
        analytics.deeplink(with: "AccountViewController")
    }
    
    @IBAction func recallApiAction(_ sender: Any) {
        APIRecallManager.shared.fetchFailApi()
    }
    
    @IBAction func makeFailApiAction(_ sender: Any) {
        APIRecallManager.shared.fetchFailApi()
    }
    
    @IBAction func trackAction(_ sender: Any) {
        let properties = ["screenName": "Home"]
        analytics.track(name: .clickButton, properties: properties)
    }
    
    @IBAction func configAction(_ sender: Any) {
        let config = Configuration()
            .setupMerchantID(value: "9cd9e0ce-12bf-492a-a81b-7aeef078b09f")
            .setupToken("f5e27185-b53d-4aee-a9b7-e0579c24d29d")
            .setupCode(code: "m-code")
            .setupSource(source: "m-source")
            .setupApi(baseUrlType: .test)
        analytics.bindConfig(config)
    }
    
    @IBAction func screenSettingAction(_ sender: Any) {
        analytics.screenSetting(title: "Home", controllerName: "HomeViewController", timeVisit: [3, 5, 10, 15])
    }
    
    @IBAction func sendTokenAction(_ sender: Any) {
        analytics.send(deviceToken: "6951158b91507454e246cbb21dce8cd29c8e0934ffe3899d02714cbbe310e69e")
    }
}
