//
//  MainVC.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import UIKit
import Hanson

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
        
        fetchData()
        detectDataChanges()
        
        pullToRefresh()
    }
    
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
    }
    
    /// Data fetch
    @objc func fetchData() {
        mainViewModel.getPosts(pullToRefresh: false)
    }
    
    /// Detect data changes and set data source + reload data
    @objc func detectDataChanges() {
        observe(mainViewModel.postsData) { postsChange in
            self.observe(self.mainViewModel.usersData) { usersDataChange in
                DispatchQueue.main.async {
                    
                    self.dataSource = MainTableViewDataSource(withData: postsChange.newValue, usersDetails: usersDataChange.newValue)
                    self.tableView.dataSource = self.dataSource
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    /// Did select table view row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Coordinator approach prepare for going to details screen
        coordinator.goToDetails(selfVC: self, userID: mainViewModel.postsData.value[indexPath.row].userID, post: mainViewModel.postsData.value[indexPath.row])
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
            self.fetchData()
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Pull to Refresh
    func pullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.backgroundColor = UIColor.systemBackground
        refreshControl.addTarget(self, action: #selector(self.fetchData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}
