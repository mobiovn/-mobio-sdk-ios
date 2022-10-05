//
//  PopupBuilderEventData.swift
//  MobioSDKSwift
//
//  Created by Sun on 27/04/2022.
//

import Foundation

struct PopupBuilderEventData: Codable {
    let key: String
    let name: String
    let fields: [PopupBuilderField]
}
