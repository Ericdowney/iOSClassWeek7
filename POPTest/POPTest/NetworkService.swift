//
//  NetworkService.swift
//  POPTest
//
//  Created by Downey, Eric on 12/18/16.
//  Copyright © 2016 ICC. All rights reserved.
//

import Foundation

// MARK: - Retroactive String Modeling

protocol CustomURLConvertible {
    var converted: URL? { get }
}

extension String: CustomURLConvertible {
    var converted: URL? {
        return URL(string: self)
    }
}

/// Trait style protocol for requesting a data task with a URLRequest and a completion block
public protocol UrlRequester {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

/// Retroactive Modeling so URLSession now conforms to URLRequester trait
extension URLSession: UrlRequester {}

/// Trait style protocol to replace DispatchQueue static call
public protocol Synchronizer {
    func sync(execute block: (Void) -> Void)
}

/// Retroactive modeling so DispatchQueue is a Synchronizer
extension DispatchQueue: Synchronizer {}

// MARK: - Network Service Interface

protocol NetworkService {
    init(urlRequester: UrlRequester, synchronizer: Synchronizer)
    func request(urlConvertible: CustomURLConvertible, with completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class DataService: NetworkService {
    
    var urlRequester: UrlRequester
    var synchronizer: Synchronizer
    
    required init(urlRequester: UrlRequester = URLSession.shared, synchronizer: Synchronizer = DispatchQueue.main) {
        self.urlRequester = urlRequester
        self.synchronizer = synchronizer
    }
    
    func request(urlConvertible: CustomURLConvertible, with completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = urlConvertible.converted else {
            completion(nil, nil, nil)
            return
        }
        let request = URLRequest(url: url)
        
        let task = urlRequester.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
}
