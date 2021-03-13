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
        detailsViewModel.delegate = self
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
                self.dataSource = DetailsTableViewDataSource(withData: self.mainViewModel.usersData.value, imageData: imageDataChange.newValue, userID: self.userID, post: self.post)
                self.tableView.dataSource = self.dataSource
                
                self.tableView.reloadData()
            }
            
        }
    }
    
    /// Did select table view row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userDetails = mainViewModel.usersData.value
        
        for user in userDetails {
            if userID == user.id {
                
                switch indexPath.row {
                case 1:
                    mail.sendMail(user.email)
                case 2:
                    launchGoogleMaps(user.address.geo.lat, user.address.geo.lng)
                case 3:
                    let phoneNumberSplit = user.phone.split(separator: " ")
                    let stringNumber = phoneNumberSplit[0].trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
                    executeCall(number: stringNumber)
                case 4:
                    print("COMPANY")
                default:
                    print("ERROR")
                }
                
            }
        }
    }
    
    /// Table view cells height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 140
        } else if indexPath.row == 5 {
            return UITableView.automaticDimension
        } else {
            return 60
        }
    }
    
    /// Load image onto the imageView
    func loadImage(imageData: Data) {
        imageViewData = imageData
    }
    
    /// Data fetched - stop refresh animations
    func stopRefresh() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            print("Y")
        }
    }
    
    /// Call phone number
    func executeCall(number: String) {
        if let url = URL(string:"tel://\(number)"), UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url)
        }
    }
    
    /// Display error alert
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in
            self.stopRefresh()
        }))
        
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { action in
            self.fetchData()
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
