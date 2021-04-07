//  iOSTask
//
//  Created by LiudasBar on 2021-03-11.
//

import Foundation
import UIKit

/// Coordinator for all coordinators
protocol Coordinator {
    func goToDetails(selfVC: UIViewController, userID: Int, postID: Int)
}

/// Coordinator for navigation between main and details VC
class MainCoordinator: Coordinator {
    
    /// Coordinator function to go to Details VC
    func goToDetails(selfVC: UIViewController, userID: Int, postID: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
            
            let vm = DetailsViewModel()
            vm.userID = userID
            vm.postID = postID
            
            detailsVC.detailsViewModel = vm
            selfVC.present(detailsVC, animated: true, completion: nil)
            
            selfVC.showDetailViewController(detailsVC, sender: nil)
        }
    }
}
