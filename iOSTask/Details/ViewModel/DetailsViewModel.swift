//
//  DetailsViewModel.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-11.
//

import Foundation
import Hanson

protocol ImageActivity {
    func loadImage(imageData: Data)
    func showError(title: String, message: String)
}

class DetailsViewModel: NSObject {
    
    private var API: FetchImage!
    var delegate: ImageActivity?
    
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
        
        API = FetchImage()
    }
    
    /// Get posts
    func getImage(userID: Int) {
        
        self.API.getImage(userID: userID) { (status, imageData, errorMessage) in
            
            //Check connection
            if NetworkReachability().isConnectedToNetwork() {
                if status {
                    //If status is OK - assign API data to postsData
                    self.imageData.value = imageData!
                    self.delegate?.loadImage(imageData: imageData!)
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

