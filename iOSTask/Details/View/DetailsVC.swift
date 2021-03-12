//
//  DetailsVC.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import UIKit
import MessageUI

class DetailsVC: UIViewController, MFMailComposeViewControllerDelegate, ImageActivity, UITableViewDelegate {
    
    var coordinator: MainCoordinator!
    
    var mail: Mail!
    
    var detailsViewModel: DetailsViewModel!
    var mainViewModel: MainViewModel!
    
    var dataSource: DetailsTableViewDataSource?
    
    var userID = Int()
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    var imageViewData = Data()
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsViewModel = DetailsViewModel()
        mainViewModel = MainViewModel()
        mail = Mail()
        
        delegatesInit()
        designInit()
        
        fetchData()
        
        pullToRefresh()
    }
    
    
    /// Design init
    func designInit() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        view.addSubview(navBar)

        let navItem = UINavigationItem(title: "User details")
        let doneItem = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: #selector(dismissView))
        navItem.leftBarButtonItem = doneItem

        navBar.setItems([navItem], animated: false)
    }
    
    /// Dismiss current VC
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Delegates init
    func delegatesInit() {
        tableView.delegate = self
        
        mail.delegate = self
    }
    
    /// Data fetch
    func fetchData() {
        detailsViewModel.getImage(userID: userID)
    }
    
    
    /// Assign data
    func askForImage() {
        detailsViewModel.bindImageData = {
            self.mainViewModel.bindUserData = {
                DispatchQueue.main.async {
                    
                    self.dataSource = DetailsTableViewDataSource(withData: self.mainViewModel.usersData, imageData: self.detailsViewModel.imageData)
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
    
    /// Load image onto the imageView
    func loadImage(imageData: Data) {
        imageViewData = imageData
    }
    
    func loadUserID(userID: Int) {
        self.userID = userID
    }
    
    /// Display error alert
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { action in
            
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Launch Google Maps based on coordinates
    func launchGoogleMaps(_ lat: String, _ lon: String) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            //Able to open Google Maps
            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(lon)") {
                UIApplication.shared.open(url)
            }
            
        } else {
            //Unable to open Google Maps
            let alert = UIAlertController(title: "Google Maps not available", message: "Please check if you have Google Maps installed on your device and try again", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.cancel, handler: { action in }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Pull to Refresh
    func pullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.backgroundColor = UIColor.systemBackground
        refreshControl.addTarget(self, action: #selector(self.fetchData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
}
