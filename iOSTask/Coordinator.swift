//
//  Coordinator.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-11.
//

import Foundation
import UIKit

protocol Coordinator {
    func goToDetails(selfVC: UIViewController,userID: Int)
}

/// Coordinator for navigation
class MainCoordinator: Coordinator {
    func goToDetails(selfVC: UIViewController ,userID: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        
        vc.userID = userID
        vc.coordinator = self
        print(userID)
        print("YOOOO")
        
        selfVC.performSegue(withIdentifier: "detailsSegue", sender: nil)
    }
}
