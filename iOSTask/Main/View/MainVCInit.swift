//  iOSTask
//
//  Created by LiudasBar on 2021-03-13.
//

import Foundation
import UIKit

extension MainVC {
    /// Delegates init
    func delegatesInit() {
        tableView.delegate = self
        mainViewModel.delegate = self
    }
    
    /// Design init
    func designInit() {
        loadingIndicator.alpha = 1
        tableView.decelerationRate = .normal
        
        navigationItem.title = "Posts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.extendedLayoutIncludesOpaqueBars = true
    }
}
