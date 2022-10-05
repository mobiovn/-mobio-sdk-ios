//
//  ResponseParse.swift
//  MobioSDKSwift
//
//  Created by Sun on 22/03/2022.
//

import Foundation

struct ResponseParse {
    
    static func parseJson(from data: Data?) -> [String: Any] {
        guard let data = data else {
            return [String: Any]()
        }
        if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let dataDictionary = jsonData as? [String: Any] {
                return dataDictionary
            }
        }
        return [String: Any]()
    }
}
