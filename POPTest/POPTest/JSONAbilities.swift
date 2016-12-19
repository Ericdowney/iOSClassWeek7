//
//  JSONAbilities.swift
//  POPTest
//
//  Created by Downey, Eric on 12/18/16.
//  Copyright © 2016 ICC. All rights reserved.
//

import Foundation

/// Trait style protocol to describe requesting json via a url with a completion block
protocol Jsonify {
    func requestJSON(from urlConvertible: CustomURLConvertible, withCompletion completion: @escaping ([String: Any]?, URLResponse?, Error?) -> Void)
}

/// Extension constrained to Service types that automatically fetches data and converts it to the JSON type
extension Jsonify where Self: NetworkService {
    
    func requestJSON(from urlConvertible: CustomURLConvertible, withCompletion completion: @escaping ([String: Any]?, URLResponse?, Error?) -> Void) {
        request(urlConvertible: urlConvertible) { data, resp, err in
            completion(self.convertToJSON(from: data), resp, err)
        }
    }
    
    private func convertToJSON(from data: Data?) -> [String: Any]? {
        guard let d = data else {
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: d, options: .allowFragments) as? [String: Any]
        }
        catch {
            return nil
        }
    }
}

/// Retroactive Modeling so BaseService objects conform to JSONData trait
extension DataService: Jsonify {}
