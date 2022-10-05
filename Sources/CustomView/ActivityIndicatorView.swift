//
//  ActivityIndicatorView.swift
//  MobioSDK
//
//  Created by Sun on 26/09/2022.
//

import UIKit

final class ActivityIndicatorView: UIActivityIndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        style = .large
        color = .white
    }
}
