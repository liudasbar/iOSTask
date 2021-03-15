//
//  testErrorRequestsAPI.swift
//  testErrorRequestsAPI
//
//  Created by LiudasBar on 2021-03-15.
//

import XCTest
@testable import iOSTask

var fetchPost: FetchPost!
var fetchPosts: FetchPosts!
var fetchUserData: FetchUserData!
var fetchImage: FetchImage!

class TestRequestsStatusAPI: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
        
        fetchPost = FetchPost()
        fetchPosts = FetchPosts()
        fetchUserData = FetchUserData()
        fetchImage = FetchImage()
    }

    override func tearDownWithError() throws {
        fetchPost = nil
        fetchPosts = nil
        fetchUserData = nil
        fetchImage = nil
        
        super.tearDown()
    }
    
    /// API request for all posts status false + errors catch
    func testPostsResponseStatus() throws {
        
        let expectation = XCTestExpectation(description: "Status true for posts response")
            
        fetchPosts.getPosts { (status, data, errorMessage) in
            
            if !status {
                XCTFail("Status false with error message: \(errorMessage!)")
            } else {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// API request for single user details status false + errors catch
    func testUserDetailsResponseStatus() throws {
        let userID = 1
        
        let expectation = XCTestExpectation(description: "Status true for user details response")
        
        fetchUserData.getUserData(userID: userID) { (status, data, errorMessage) in
            
            if !status {
                XCTFail("Status false with error message: \(errorMessage!)")
            } else {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// API request for single post status false + errors catch
    func testPostDetailsResponseStatus() throws {
        let postID = 1
        
        let expectation = XCTestExpectation(description: "Status true for post details response")
            
        fetchPost.getPost(postID: postID) { (status, data, errorMessage) in
            
            if !status {
                XCTFail("Status false with error message: \(errorMessage!)")
            } else {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// API request for image status false + errors catch
    func testImageResponse200() throws {
        let userID = 1
        
        
        let expectation = XCTestExpectation(description: "Status true for image response")
            
        fetchImage.getImage(userID: userID) { (status, data, errorMessage) in
            
            if !status {
                XCTFail("Status false with error message: \(errorMessage!)")
            } else {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
