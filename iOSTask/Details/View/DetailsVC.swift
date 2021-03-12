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
    var post = Post(userID: 0, id: 0, title: "", body: "")
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    var imageViewData = Data()
    
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsViewModel = DetailsViewModel()
        mainViewModel = MainViewModel()
        mail = Mail()
        
        delegatesInit()
        
        fetchData()
        
        askForImage()
        
        pullToRefresh()
    }
    
    
    
    /// Delegates init
    func delegatesInit() {
        tableView.delegate = self
        
        mail.delegate = self
    }
    
    /// Data fetch
    @objc func fetchData() {
        mainViewModel.getPosts(pullToRefresh: false)
        detailsViewModel.getImage(userID: userID)
    }
    
    
    /// Detect data changes and set data source + reload data
    func askForImage() {
        observe(detailsViewModel.imageData) { imageDataChange in
            DispatchQueue.main.async {
                print("3")
                self.dataSource = DetailsTableViewDataSource(withData: self.mainViewModel.usersData.value, imageData: imageDataChange.newValue, post: self.post)
                self.tableView.dataSource = self.dataSource
                
                print(self.userID)
                
                self.tableView.reloadData()
            }
            
        }
    }
    
    /// Did select table view row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 1:
            print("EMAIL")
        case 2:
            print("ADDRESS")
        case 3:
            print("PHONE NUMBER")
        case 4:
            print("COMPANY")
        default:
            print("ERROR ON SELECTION")
        }
    }
    
    /// Table view cells height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 140
        } else if indexPath.row == 5 {
            return 300
        } else {
            return UITableView.automaticDimension
        }
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
        tableView.refreshControl = refreshControl
    }
}
