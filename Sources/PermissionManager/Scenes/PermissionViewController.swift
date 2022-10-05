//
//  PermissionViewController.swift
//  PermissionApp
//
//  Created by Sun on 08/09/2022.
//

import UIKit

@available(iOSApplicationExtension, unavailable)
final class PermissionViewController: UIViewController, XibSceneBased {
    
    // MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Define
    struct Constant {
        static let tableHeaderHeight: CGFloat = 70
    }
    
    // MARK: - Property
    var permissionObjectArray: [PermissionObject] = [LocationPermissionObject(), NotificationPermissionObject()]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    private func setupData() {
        tableView.dataSource = self
        tableView.delegate = self
        let permissionNib = UINib(nibName: PermissionCell.nibName, bundle: AppInfo.mobioSDKBundle)
        tableView.register(permissionNib, forCellReuseIdentifier: PermissionCell.nibName)
        let permissionHeaderNib = UINib(nibName: PermissionHeaderCell.nibName, bundle: AppInfo.mobioSDKBundle)
        tableView.register(permissionHeaderNib,
                           forHeaderFooterViewReuseIdentifier: PermissionHeaderCell.nibName)
        title = "Register Permissions"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                            target: self,
                                                            action: #selector(closeAction))
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    // MARK: - Action
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}

@available(iOSApplicationExtension, unavailable)
extension PermissionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return permissionObjectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PermissionCell.nibName, for: indexPath) as? PermissionCell else {
            return UITableViewCell()
        }
        cell.setupData(data: permissionObjectArray[indexPath.row])
        cell.delegate = self
        return cell
    }
}

@available(iOSApplicationExtension, unavailable)
extension PermissionViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PermissionHeaderCell.nibName) as? PermissionHeaderCell else { return UIView() }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constant.tableHeaderHeight
    }
}

@available(iOSApplicationExtension, unavailable)
extension PermissionViewController: PermissionCellDelegate {
  
    func gotoSettingScreen() {
        let settingsButton = "Settings"
        let cancelButton = "Cancel"
        let message = "Your need to give a permission from notification settings."
        let goToSettingsAlert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        goToSettingsAlert.addAction(UIAlertAction(title: settingsButton, style: .destructive, handler: { (action: UIAlertAction) in
                if let appSettings = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
        }))
        goToSettingsAlert.addAction(UIAlertAction(title: cancelButton, style: .cancel, handler: nil))
        present(goToSettingsAlert, animated: true)
    }
}
