//
//  MainTableViewController.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import UIKit

/// Table view data source
class MainTableViewDataSource: NSObject, UITableViewDataSource {
    
    var posts = MainViewModel().postsData
    var usersDetails = MainViewModel().usersData
    
    init(withData data: [Post], usersDetails: [UserDetails]) {
        self.posts = data
        self.usersDetails = usersDetails
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        
        let post = posts![indexPath.row]
        
        cell.titleLabel.text = post.title
        cell.bodyLabel.text = post.body
        
        for userDetails in usersDetails! {
            if post.userID == userDetails.id {
                cell.userDataLabel.text = userDetails.username + " - " + userDetails.company.name
            }
        }
        
        return cell
    }
}
