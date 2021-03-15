//
//  DetailsViewModelRequestAPI.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-15.
//

import Foundation
import UIKit

extension DetailsViewModel {
    /// Get image
    func getImage(userID: Int) {
        
        self.imageAPI.getImage(userID: userID) { (status, imageData, errorMessage) in
            
            //Check connection
            if NetworkReachability().isConnectedToNetwork() {
                if status {
                    //If status is OK - assign API data to imageData
                    self.imageData.value = imageData!
                    self.delegate?.stopRefresh()
                } else {
                    self.delegate?.showError(title: "Image could not be loaded", message: "Error occured. Description: \(errorMessage!)")
                }
            }
        }
    }
    
    /// Get single post
    func getPost(postID: Int) {
        
        self.postAPI.getPost(postID: postID) { (status, postData, errorMessage) in
            
            //Check connection
            if NetworkReachability().isConnectedToNetwork() {
                if status {
                    //If status is OK - assign API data to postData
                    self.postData.value = postData!
                    self.mainViewModel.getPosts(pullToRefresh: false)
                    self.delegate?.stopRefresh()
                } else {
                    self.delegate?.showError(title: "Post could not be loaded", message: "Error occured. Description: \(errorMessage!)")
                }
            } else {
                //Network unreachable
                self.mainViewModel.getPosts(pullToRefresh: false)
                self.mainViewModel.getUsersDetails()
                self.delegate?.stopRefresh()
                
                self.retrieveDatabasePost(postID: postID)
            }
        }
    }
    
    /// Get post
    func getSingleUser(userID: Int) {
        
        self.userAPI.getUserData(userID: userID) { (status, singleUserData, errorMessage) in
            
            //Check connection
            if NetworkReachability().isConnectedToNetwork() {
                if status {
                    //If status is OK - assign API data to userData
                    self.userData.value = singleUserData!
                    self.mainViewModel.getUsersDetails()
                    self.delegate?.stopRefresh()
                } else {
                    self.delegate?.showError(title: "User data could not be loaded", message: "Error occured. Description: \(errorMessage!)")
                }
            } else {
                //Network unreachable
                self.retrieveDatabaseUserDetails(userID: userID)
                self.delegate?.stopRefresh()
            }
        }
    }
}
