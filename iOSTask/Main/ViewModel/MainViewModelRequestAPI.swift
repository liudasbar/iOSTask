//  iOSTask
//
//  Created by LiudasBar on 2021-03-15.
//

import Foundation
import UIKit

extension MainViewModel {
    /// Get posts data
    func getPosts(pullToRefresh: Bool) {
        
        //Check connection
        if NetworkReachability().isConnectedToNetwork() {
            self.postsAPI!.getPosts { (status, data, errorMessage) in
                
                if pullToRefresh {
                    self.delegate?.startRefresh()
                }
                
                if status {
                    //If status is OK - assign API data to postsData
                    self.postsData.value = data!
                    
                    self.removeDatabasePosts()
                    
                    self.saveDatabasePosts()
                    
                    self.getUsersDetails()
                    
                } else {
                    self.delegate?.stopRefresh()
                    self.delegate?.showError(title: "Posts could not be loaded", message: "Error occured. Description: \(errorMessage!)")
                }
            }
            
        } else {
            //Network unreachable
            //Remove all posts data
            self.postsData.value.removeAll()
            
            //Retrieve database data
            self.retrieveDatabasePosts()
            
            self.getUsersDetails()
        }
    }
    
    /// Get users details data
    func getUsersDetails() {
        //Array of all users IDs
        var userIDs: [Int] = []
        
        //Check connection
        if NetworkReachability().isConnectedToNetwork() {
            for post in postsData.value {
                
                //Append user ID only if it is not present in the array
                if !userIDs.contains(post.userID) {
                    userIDs.append(post.userID)
                    
                    self.userDetailsAPI!.getUserData(userID: post.userID) { (status, data, errorMessage) in
                        
                        if status {
                            //If status is OK - assign API data to usersData
                            self.usersData.value.append(data!)
                            
                            self.removeDatabaseUersDetails()
                            
                            self.saveUsersDetailsPosts()
                            
                            self.delegate?.stopRefresh()
                        } else {
                            self.delegate?.stopRefresh()
                            self.delegate?.showError(title: "User details could not be loaded", message: "Error occured. Description: \(errorMessage!)")
                        }
                    }
                }
            }
            
        } else {
            //Network unreachable
            //Remove all users data
            self.usersData.value.removeAll()
            
            //Retrieve database data
            self.retrieveDatabaseUsersDetails()
            
            self.delegate?.stopRefresh()
            self.delegate?.showError(title: "You seem to be offline", message: "Showing offline data. Please reconnect to a network for the newest information.")
        }
    }
}
