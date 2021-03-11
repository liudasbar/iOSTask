//
//  DetailsViewModel.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-11.
//

import Foundation
import UIKit

protocol ImageActivity {
    func passImage(imageData: Data)
    func showError(title: String, message: String)
}

class DetailsModelView: NSObject {
    
    private var API: FetchImage!
    var delegate: ImageActivity?
    
    override init() {
        super.init()
        
        API = FetchImage()
    }
    
    /// Get posts
    func getImage() {
        //PADUOTI ID CIA
        self.API.getImage(userID: Int()) { (status, imageData, errorMessage) in
            
            //Check connection
            if NetworkReachability().isConnectedToNetwork() {
                if status {
                    //If status is OK - assign API data to postsData
                    self.delegate?.passImage(imageData: imageData!)
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

