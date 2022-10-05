//
//  DeviceManager.swift
//  MobioSDKSwift
//
//  Created by sun on 21/04/2022.
//

import UIKit

struct DeviceManager {
    
    static func getModel() -> String {
        var nameArray: [Int32] = [CTL_HW, HW_MACHINE]
        var size: Int = 2
        sysctl(&nameArray, 2, nil, &size, nil, 0)
        var hwMachine = [CChar](repeating: 0, count: Int(size))
        sysctl(&nameArray, 2, &hwMachine, &size, nil, 0)
        let model = String(cString: hwMachine)
        return model
    }
    
    static func getName() -> String {
        return UIDevice.current.name
    }
    
    static func getType() -> String {
        return UIDevice.current.systemName
    }
    
    static func getManufacturer() -> String {
        return "Apple"
    }
}
