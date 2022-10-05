//
//  PermissionManager.swift
//  PermissionApp
//
//  Created by Sun on 09/09/2022.
//

import UIKit

@available(iOSApplicationExtension, unavailable)
struct PermissionManager {
    
    // MARK: - Define
    enum PermissionCase {
        case location
        case notification
        
        var permissionObject: PermissionObject {
            switch self {
            case .location:
                return LocationPermissionObject()
            case .notification:
                return NotificationPermissionObject()
            }
        }
    }
    
    // MARK: - Property
    let listPermissionCase: [PermissionCase]
    let permissionViewController = PermissionViewController.instantiate()
    
    // MARK: - Data
    private func showListPermission(listPermission: [PermissionObject]) {
        permissionViewController.permissionObjectArray = listPermission
        let navController = UINavigationController(rootViewController: permissionViewController)
        navController.navigationBar.prefersLargeTitles = true
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
        let topController = keyWindow?.rootViewController
        topController?.present(navController, animated: true, completion: nil)
    }
    
    func checkStatusListPermission() {
        let listPermission = listPermissionCase.map { permissionCase in
            return permissionCase.permissionObject
        }
        var isAllPermissionAllow = true
        let group = DispatchGroup()
        listPermission.forEach { permissionObject in
            group.enter()
            permissionObject.checkStatus { permissionStatus in
                if permissionStatus == .notAllow {
                    isAllPermissionAllow = false
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            if isAllPermissionAllow == false {
                showListPermission(listPermission: listPermission)
            }
        }
    }
    
    func reload() {
        permissionViewController.reload()
    }
}
