//
//  DetailsTableController.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-11.
//

import Foundation
import UIKit

/// Table view data source
class DetailsTableViewDataSource: NSObject, UITableViewDataSource {
    
    var usersDetails = MainViewModel().usersData
    var imageData = Data()
    var userID = Int()
    var post: Post
    
    init(withData usersDetails: UsersDetails, imageData: Data, post: Post) {
        self.usersDetails.value = usersDetails
        self.imageData = imageData
        self.post = post
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            //Details first cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsFirstCell", for: indexPath) as! DetailsFirstCell
            
            let userDetails = usersDetails.value
            var name = ""
            for user in userDetails {
                if userID == user.id {
                    name = user.name
                }
            }
            
            cell.profileImageView?.image = UIImage(data: imageData)
            cell.nameLabel.text = name
            
            return cell
            
        } else if indexPath.row > 0 && indexPath.row < 5 {
            //Details info cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsDataCell", for: indexPath) as! DetailsDataCell
            
            let post = usersDetails.value[indexPath.row]
            
            cell.detailsIconImageView.image = UIImage(systemName: "location.fill")
            cell.detailsInfoLabel.text = "aa"
            
            switch indexPath.row {
            case 1:
                cell.detailsIconImageView.image = UIImage(systemName: "globe")
            case 2:
                cell.detailsIconImageView.image = UIImage(systemName: "location.circle.fill")
            case 3:
                cell.detailsIconImageView.image = UIImage(systemName: "phone.circle.fill")
            case 4:
                cell.detailsIconImageView.image = UIImage(systemName: "building.2.crop.circle")
            default:
                print("ERROR: \(indexPath.row)")
                cell.detailsIconImageView.image = UIImage(systemName: "")
            }
            
            return cell
            
        } else {
            //Post cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! DetailsPostCell
            
            cell.postTitle.text = post.title
            cell.postBody.text = post.body
            
            return cell
        }
    }
}
