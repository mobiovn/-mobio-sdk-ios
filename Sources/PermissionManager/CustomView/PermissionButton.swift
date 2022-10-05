//
//  PermissionButton.swift
//  PermissionApp
//
//  Created by Sun on 07/09/2022.
//

import UIKit

enum PermissionStatus {
    case notAllow
    case allowed
}

final class PermissionButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = frame.height / 2
    }
    
    func checkPermissionStatus(_ permissionStatus: PermissionStatus) {
        switch permissionStatus {
        case .notAllow:
            setupNotAllowStatus()
        case .allowed:
            setupAllowedStatus()
        }
    }
    
    private func setupNotAllowStatus() {
        backgroundColor = .systemGray4
        tintColor = .systemBlue
        setTitle("ALLOW", for: .normal)
    }
    
    private func setupAllowedStatus() {
        backgroundColor = .systemBlue
        tintColor = .white
        setTitle("ALLOWED", for: .normal)
    }
}
