//
//  Coordinator.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-11.
//

import Foundation
import UIKit

/// Coordinator for all coordinators
protocol Coordinator {
    func goToDetails(selfVC: UIViewController,userID: Int)
}

/// Coordinator for navigation between main and details VC
class MainCoordinator: Coordinator {
    func goToDetails(selfVC: UIViewController ,userID: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
            detailsVC.userID = userID
            detailsVC.coordinator = self
            
            selfVC.performSegue(withIdentifier: "detailsSegue", sender: nil)

        }
    }
    
    
}
