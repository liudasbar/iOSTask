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
    
    init(withData usersDetails: UsersDetails, imageData: Data, userID: Int, post: Post) {
        self.usersDetails.value = usersDetails
        self.imageData = imageData
        self.userID = userID
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
            
            let userDetails = usersDetails.value
            
            for user in userDetails {
                if userID == user.id {
                    
                    switch indexPath.row {
                    case 1:
                        cell.detailsIconImageView.image = UIImage(systemName: "globe")
                        cell.detailsInfoLabel.text = user.email
                    case 2:
                        cell.detailsIconImageView.image = UIImage(systemName: "location.circle.fill")
                        cell.detailsInfoLabel.text = user.address.street + " " + user.address.suite + " " + user.address.city + " " + user.address.zipcode
                    case 3:
                        cell.detailsIconImageView.image = UIImage(systemName: "phone.circle.fill")
                        cell.detailsInfoLabel.text = user.phone
                    case 4:
                        cell.detailsIconImageView.image = UIImage(systemName: "building.2.crop.circle")
                        cell.detailsInfoLabel.text = user.company.name
                    default:
                        print("ERROR: \(indexPath.row)")
                        cell.detailsIconImageView.image = UIImage(systemName: "xmark")
                        cell.detailsInfoLabel.text = user.company.name
                    }
                    
                }
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
