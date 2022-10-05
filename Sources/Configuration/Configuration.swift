//
//  Configuration.swift
//  AppDemo
//
//  Created by LinhNobi on 30/09/2021.
//

import Foundation

@objcMembers public class Configuration: NSObject {
    
    var sdk: SDK!
    public var baseUrlType: BaseUrlType!
    var canSendDataBackToEnd: Bool!
    var delegate: ConfigurationDelegate?
    var dontTrackBaseEvent: [BaseEventKey]!

    public override init() {
        sdk = SDK()
        baseUrlType = BaseUrlType.app
        canSendDataBackToEnd = true
        dontTrackBaseEvent = [BaseEventKey]()
    }
    
    /// Save merchantID
    ///
    /// In example.
    /// Create a configuration.
    ///
    ///     let config = Configuration()
    ///                  .setMerchantID(value: "xxxxxxxx-aaaa")
    ///
    /// - Parameter value: merchantID string.
    public func setupMerchantID(value: String) -> Configuration {
        UserDefaultManager.set(value: value, forKey: .merchantID)
        return self
    }

    /// Save token
    ///
    /// In example.
    /// Create a configuration.
    ///
    ///     let config = Configuration()
    ///                  .setupToken(value: "xxxxxxxx-aaaa")
    ///
    /// - Parameter value: token string.
    public func setupToken(_ value: String) -> Configuration {
        UserDefaultManager.set(value: value, forKey: .token)
        return self
    }
    
    /// Set code for SDK object.
    ///
    /// In example.
    ///
    ///     analytics.setupCode(code: "m-code")
    ///
    /// - Parameter code: code data.
    public func setupCode(code: String) -> Configuration {
        sdk.code = code
        return self
    }
    
    /// Set source for SDK object.
    ///
    /// In example.
    ///
    ///     analytics.setupSource(source: "m-source")
    ///
    /// - Parameter source: source data.
    public func setupSource(source: String) -> Configuration {
        sdk.source = source
        return self
    }
    
    /// Setup environment: test, app,  uat
    ///
    /// In example.
    ///
    ///     analytics.setupApi(baseUrlType: .test)
    public func setupApi(baseUrlType: BaseUrlType) -> Configuration {
        self.baseUrlType = baseUrlType
        return self
    }
    
    @discardableResult
    public func setupCanSendDataBackToEnd(_ value: Bool?) -> Configuration {
        self.canSendDataBackToEnd = value ?? true
        delegate?.trackableDidSet(value: canSendDataBackToEnd)
        return self
    }
    
    @discardableResult
    public func setupDontTrackBaseEvent(_ array: [BaseEventKey]) -> Configuration {
        self.dontTrackBaseEvent = array
        return self
    }
}
