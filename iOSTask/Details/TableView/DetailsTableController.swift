//
//  DetailsTableController.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-11.
//

import Foundation
import UIKit

/// Table view delegate
class DetailsTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var delegate: ViewControllerDelegate?
    
    init(withDelegate delegate: ViewControllerDelegate) {
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 140
        } else {
            return 60
        }
    }
}


/// Table view data source
class DetailsTableViewDataSource: NSObject, UITableViewDataSource {
    
    var usersDetails = MainViewModel().usersData
    var imageData = Data()
    var userID = Int()
    
    init(withData usersDetails: UsersDetails, imageData: Data) {
        self.usersDetails = usersDetails
        self.imageData = imageData
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            //Details first cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsFirstCell", for: indexPath) as! DetailsFirstCell
            
            let userDetails = usersDetails![indexPath.row]
            
            cell.imageView?.image = UIImage(data: imageData)
            cell.nameLabel.text = userDetails.name
            
            return cell
            
        } else {
            //Details info cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsDataCell", for: indexPath) as! DetailsDataCell
            
            let post = usersDetails![indexPath.row]
            
            cell.detailsIconImageView.image = UIImage(systemName: "")
            cell.detailsInfoLabel.text = ""
            
            return cell
        }
    }
}
