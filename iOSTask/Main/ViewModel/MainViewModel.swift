//
//  MainViewModel.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import Foundation

/// Activity indicator protocol
protocol Activity {
    func startRefresh()
    func stopRefresh()
    func showError(title: String, message: String)
}

class MainViewModel: NSObject {
    
    private var postsAPI: FetchPosts!
    private var userDetailsAPI: FetchUserData!
    var delegate: Activity?
    
    private(set) var postsData: Posts! {
        didSet {
            //Notifies the view about posts data changes
            self.bindPostData()
        }
    }
    
    private(set) var usersData: UsersDetails! = [] {
        didSet {
            self.bindUserData()
        }
    }
    
    var bindPostData: (() -> ()) = {}
    var bindUserData: (() -> ()) = {}
    
    override init() {
        super.init()
        
        postsAPI = FetchPosts()
        userDetailsAPI = FetchUserData()
    }
    
    /// Get posts
    func getPosts(pullToRefresh: Bool) {
        //Fetch posts data
        //Network reachable
        self.postsAPI.getPosts { (status, data, errorMessage) in
            
            if !pullToRefresh {
                self.delegate?.startRefresh()
            }
            
            //Check connection
            if NetworkReachability().isConnectedToNetwork() {
                if status {
                    //If status is OK - assign API data to postsData
                    self.postsData = data
                    
                    self.getUsersDetails()
                } else {
                    self.delegate?.stopRefresh()
                    self.delegate?.showError(title: "Posts could not be loaded", message: "Error occured. Description: \(String(describing: errorMessage))")
                }
            } else {
                //Network unreachable
                self.delegate?.stopRefresh()
                self.delegate?.showError(title: "You seem to be offline", message: "Please reconnect to a network and check for any updates again.")
            }
        }
    }
    
    /// Get users details
    func getUsersDetails() {
        //Array of all users IDs
        var userIDs: [Int] = []
        
        for post in postsData {
            //Append user ID only if it is not present in the array
            if !userIDs.contains(post.userID) {
                userIDs.append(post.userID)
                
                //Fetch users data
                //Network reachable
                self.userDetailsAPI.getUserData(userID: post.userID) { (status, data, errorMessage) in
                    
                    if status {
                        //If status is OK - assign API data to usersData
                        if data != nil {
                            self.usersData.append(data!)
                        }
                        
                        self.delegate?.stopRefresh()
                    } else {
                        self.delegate?.stopRefresh()
                        self.delegate?.showError(title: "User details could not be loaded", message: "Error occured. Description: \(String(describing: errorMessage))")
                    }
                }
            }
        }
    }
}
