//
//  testNetworkRaechability.swift
//  testNetworkRaechability
//
//  Created by LiudasBar on 2021-03-15.
//

import XCTest
@testable import iOSTask

var reachability: NetworkReachability?

class TestNetworkReachability: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
        
        reachability = NetworkReachability()
    }

    override func tearDownWithError() throws {
        reachability = nil
        
        super.tearDown()
    }
    
    func testNetworkOnline() throws {
        let expectation = XCTestExpectation(description: "Device is online")
        
        if reachability!.isConnectedToNetwork() {
            expectation.fulfill()
        } else {
            XCTFail("Device is offline")
        }
    }
}
