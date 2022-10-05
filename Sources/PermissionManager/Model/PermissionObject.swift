//
//  PermissionObject.swift
//  PermissionApp
//
//  Created by Sun on 07/09/2022.
//

import UIKit

@available(iOSApplicationExtension, unavailable)
protocol PermissionObject {
    
    // MARK: - Define
    typealias VoidHandler = (PermissionStatus) -> Void
    
    // MARK: - Property
    var permissionHandler: VoidHandler? { get set }
    var name: String { get set }
    var summany: String { get set }
    var emptyImage: String { get set }
    var fullImage: String { get set }
    
    // MARK: - func
    func requestPermission()
    func checkStatus(handler: @escaping (PermissionStatus) -> Void)
}

@available(iOSApplicationExtension, unavailable)
extension PermissionObject {
    
    func suggetOpenSetting() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings)
        }
    }
}
