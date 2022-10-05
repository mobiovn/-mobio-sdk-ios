//
//  BaseEventKey.swift
//  MobioSDKSwift
//
//  Created by Sun on 29/08/2022.
//

import Foundation

@objcMembers public class BaseEventKey: NSObject {
    
    var keyName: String = ""
    
    init(keyName: String) {
        self.keyName = keyName
    }
    
    public static let screenStart = BaseEventKey(keyName: "sdk_mobile_test_screen_start_in_app")
    public static let timeVisit = BaseEventKey(keyName: "sdk_mobile_time_visit_app")
    public static let clickButton = BaseEventKey(keyName: "sdk_mobile_test_click_button_in_app")
    public static let screenEnd = BaseEventKey(keyName: "test_sdk_mobile_screen_end_in_app")
    public static let openFirst = BaseEventKey(keyName: "sdk_mobile_test_open_first_app")
    public static let install = BaseEventKey(keyName: "sdk_mobile_test_installed_app")
    public static let update = BaseEventKey(keyName: "sdk_mobile_test_open_update_app")
    public static let openApp = BaseEventKey(keyName: "sdk_mobile_test_open_app")
    public static let scroll = BaseEventKey(keyName: "Scroll Event")
    public static let identifyApp = BaseEventKey(keyName: "sdk_mobile_test_identify_app")
}
