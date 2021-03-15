//
//  MainTableViewController.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import UIKit

/// Table view data source
class MainTableViewDataSource: NSObject, UITableViewDataSource {
    
    var viewModel = MainViewModel()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postsData.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        
        let post = viewModel.postsData.value[indexPath.row]
        
        cell.titleLabel.text = post.title
        cell.bodyLabel.text = post.body
        
        //Show user details on cell only if userID matches its correct value
        for userDetails in viewModel.usersData.value {
            if post.userID == userDetails.id {
                cell.userDataLabel.text = userDetails.username + " - " + userDetails.company.name
            }
        }
        
        return cell
    }
}
