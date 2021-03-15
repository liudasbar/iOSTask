//
//  testDataRequestsAPI.swift
//  testDataRequestsAPI
//
//  Created by LiudasBar on 2021-03-15.
//

import XCTest
@testable import iOSTask

class TestDataParsingRequestsAPI: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
        
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    /// Parsing check for posts
    func testPostsResponse200() throws {
        let url =
            URL(string: "https://jsonplaceholder.typicode.com/posts")
        
        let expectation = XCTestExpectation(description: "Posts data parsing successful")
            
        let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            
            //Request error
            if error != nil {
                XCTFail("Error: \(error!)")
                return
            }
            
            if data != nil {
                //Returning API value
                if let data = data {
                    do {
                        let _ = try JSONDecoder().decode(Posts.self, from: data)
                        
                        expectation.fulfill()
                        
                    } catch let errorMessage {
                        //Parsing error
                        XCTFail("Parsing error: \(errorMessage)")
                    }
                }
            }
        })
        dataTask.resume()
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// Parsing check for user details
    func testUserDetailsResponseParsing() throws {
        let userID = 1
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(userID)")
        
        let expectation = XCTestExpectation(description: "User details data parsing successful")
        
        let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            
            //Request error
            if error != nil {
                XCTFail("Error: \(error!)")
                return
            }
            
            if data != nil {
                //Returning API value
                if let data = data {
                    do {
                        let _ = try JSONDecoder().decode(UserDetailsStruct.self, from: data)
                        
                        expectation.fulfill()
                        
                    } catch let errorMessage {
                        //Parsing error
                        XCTFail("Parsing error: \(errorMessage)")
                    }
                }
            }
        })
        dataTask.resume()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// Parsing check for post details
    func testPostDetailsResponse200() throws {
        let postID = 1
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postID)")
        
        let expectation = XCTestExpectation(description: "Post data parsing successful")
            
        let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            
            //Request error
            if error != nil {
                XCTFail("Error: \(error!)")
                return
            }
            
            if data != nil {
                //Returning API value
                if let data = data {
                    do {
                        let _ = try JSONDecoder().decode(PostStruct.self, from: data)
                        
                        expectation.fulfill()
                        
                    } catch let errorMessage {
                        //Parsing error
                        XCTFail("Parsing error: \(errorMessage)")
                    }
                }
            }
        })
        dataTask.resume()
        wait(for: [expectation], timeout: 5.0)
    }
}
