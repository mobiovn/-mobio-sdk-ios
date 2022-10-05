//
//  BaseUrlType.swift
//  MobioSDKSwift
//
//  Created by Sun on 22/06/2022.
//

import Foundation

@objcMembers public class BaseUrlType: NSObject {
    
    var urlString: String = ""
    
    public init(urlString: String) {
        self.urlString = urlString
    }
    
    public static let app = BaseUrlType(urlString: "https://api.mobio.vn/")
    public static let uat = BaseUrlType(urlString: "https://api-uat.mobio.vn/")
    public static let test = BaseUrlType(urlString: "https://api-test1.mobio.vn/")
    
}
