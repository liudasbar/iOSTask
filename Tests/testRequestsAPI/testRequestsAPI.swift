//
//  iOSTaskTests.swift
//  iOSTaskTests
//
//  Created by LiudasBar on 2021-03-10.
//

import XCTest
@testable import iOSTask

var fetchPost: FetchPost!
var fetchPosts: FetchPosts!
var fetchUserData: FetchUserData!

class testRequestsAPI: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
        
        fetchPost = FetchPost()
        fetchPosts = FetchPosts()
        fetchUserData = FetchUserData()
    }

    override func tearDownWithError() throws {
        fetchPost = nil
        fetchPosts = nil
        fetchUserData = nil
        
        super.tearDown()
    }
    
    /// API request for all posts
    func testPostsResponse200() throws {
        let url =
            URL(string: "https://jsonplaceholder.typicode.com/posts")
        
        let expectation = XCTestExpectation(description: "Response status code: 200")
            
        fetchPosts.getPosts { (status, data, errorMessage) in
            
            let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                
                //Request error
                if error != nil {
                    XCTFail("Error: \(errorMessage!)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        expectation.fulfill()
                    }
                }
            })
            dataTask.resume()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// API request for single user details
    func testUserDetailsResponse200() throws {
        let userID = 1
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(userID)")
        
        let expectation = XCTestExpectation(description: "Response status code: 200")
            
        fetchUserData.getUserData(userID: userID) { (status, data, errorMessage) in
            
            let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                
                //Request error
                if error != nil {
                    XCTFail("Error: \(errorMessage!)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        expectation.fulfill()
                    }
                }
            })
            dataTask.resume()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// API request for single post
    func testPostDetailsResponse200() throws {
        let postID = 1
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postID)")
        
        let expectation = XCTestExpectation(description: "Response status code: 200")
            
        fetchPost.getPost(postID: postID) { (status, data, errorMessage) in
            
            let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                
                //Request error
                if error != nil {
                    XCTFail("Error: \(errorMessage!)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        expectation.fulfill()
                    }
                }
            })
            dataTask.resume()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
