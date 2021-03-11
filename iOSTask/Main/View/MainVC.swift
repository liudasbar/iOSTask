//
//  MainVC.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import UIKit

class MainVC: UIViewController, Activity, UITableViewDelegate {
    
    var coordinator: MainCoordinator!
    
    var mainViewModel: MainViewModel!
    var dataSource: MainTableViewDataSource?
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewModel = MainViewModel()
        coordinator = MainCoordinator()
        
        delegatesInit()
        designInit()
        
        fillData()
        
        pullToRefresh()
    }
    
    
    /// Delegates init
    func delegatesInit() {
        tableView.delegate = self
        
        mainViewModel.delegate = self
        
        fetchData()
        
       
    }
    
    /// Design init
    func designInit() {
        loadingIndicator.alpha = 1
        tableView.decelerationRate = .normal
    }
    
    /// Initial data fetch
    func fetchData() {
        mainViewModel.getPosts(pullToRefresh: false)
    }
    
    /// Fill table view with data
    @objc func fillData() {
        mainViewModel.bindPostData = {
            self.mainViewModel.bindUserData = {
                DispatchQueue.main.async {
                    
                    self.dataSource = MainTableViewDataSource(withData: self.mainViewModel.postsData, usersDetails: self.mainViewModel.usersData)
                    self.tableView.dataSource = self.dataSource
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    /// Did select table view row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(mainViewModel.postsData[indexPath.row].title)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Coordinator approach prepare for going to details screen
        coordinator.goToDetails(selfVC: self, userID: mainViewModel.postsData[indexPath.row].userID)
    }
    
    /// Data started fetching - start refresh animations
    func startRefresh() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }
    }
    
    /// Data fetched - stop refresh animations
    func stopRefresh() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    
    /// Display error alert
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in
            self.stopRefresh()
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { action in
            self.refresh()
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Pull to Refresh
    func pullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.backgroundColor = UIColor.systemBackground
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    /// Refresh action
    @objc func refresh() {
        mainViewModel.getPosts(pullToRefresh: true)
    }
}
