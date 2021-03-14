//
//  DetailsViewModel.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-11.
//

import Foundation
import Hanson

protocol APIActivity {
    func showError(title: String, message: String)
    func stopRefresh()
}

class DetailsViewModel: NSObject {
    
    private var imageAPI: FetchImage!
    private var userAPI: FetchUserData!
    private var postAPI: FetchPost!
    var delegate: APIActivity?
    
    var postData = Observable(PostStruct(userID: 0, id: 0, title: "", body: ""))
    var userData = Observable(UserDetailsStruct(id: 0, name: "", username: "", email: "", address: AddressStruct(street: "", suite: "", city: "", zipcode: "", geo: GeoStruct(lat: "", lng: "")), phone: "", website: "", company: CompanyStruct(name: "", catchPhrase: "", bs: "")))
    var imageData = Observable(Data())
    
//    private(set) var imageData: Data! {
//        didSet {
//            self.bindImageData()
//        }
//    }
//
//    var bindImageData: (() -> ()) = {}
    
    override init() {
        super.init()
        
        imageAPI = FetchImage()
        userAPI = FetchUserData()
        postAPI = FetchPost()
    }
    
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
                    self.delegate?.showError(title: "Image could not be loaded", message: "Error occured. Description: \(String(describing: errorMessage))")
                }
            } else {
                //Network unreachable
                self.delegate?.showError(title: "You seem to be offline", message: "Please reconnect to a network and check for any updates again.")
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
                    self.delegate?.stopRefresh()
                } else {
                    self.delegate?.showError(title: "Image could not be loaded", message: "Error occured. Description: \(String(describing: errorMessage))")
                }
            } else {
                //Network unreachable
                self.delegate?.showError(title: "You seem to be offline", message: "Please reconnect to a network and check for any updates again.")
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
                    self.delegate?.stopRefresh()
                } else {
                    self.delegate?.showError(title: "Image could not be loaded", message: "Error occured. Description: \(String(describing: errorMessage))")
                }
            } else {
                //Network unreachable
                self.delegate?.showError(title: "You seem to be offline", message: "Please reconnect to a network and check for any updates again.")
            }
        }
    }
}

