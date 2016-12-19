//
//  ServiceTests.swift
//  POPTest
//
//  Created by Downey, Eric on 12/18/16.
//  Copyright © 2016 ICC. All rights reserved.
//

import XCTest
@testable import POPTest

class ServiceTests: XCTestCase {
    
    var mockSynchronizer: MockSynchronizer!
    var mockUrlRequester: MockUrlRequester!
    var subject: NetworkService & Jsonify!
    
    override func setUp() {
        super.setUp()
        
        mockSynchronizer = MockSynchronizer()
        mockUrlRequester = MockUrlRequester()
        subject = DataService(urlRequester: mockUrlRequester, synchronizer: mockSynchronizer)
    }
    
    func testShouldSendAUrlRequest() {
        let urlString = "http://localhost"
        
        subject.request(urlConvertible: urlString, with: {_ in})
        
        XCTAssertEqual(mockUrlRequester.invocations, 1)
        XCTAssertEqual(mockUrlRequester.mockDataTask.invocations, 1)
    }
    
    // MARK: - Mocks
    
    class MockSynchronizer: Synchronizer {
        var invocations = 0
        func sync(execute block: (Void) -> Void) {
            invocations += 1
        }
    }
    
    class MockUrlRequester: UrlRequester {
        var mockDataTask = MockDataTask()
        var invocations = 0
        
        func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            invocations += 1
            return mockDataTask
        }
    }
    
    class MockDataTask: URLSessionDataTask {
        var invocations = 0
        override func resume() {
            invocations += 1
        }
    }
}
