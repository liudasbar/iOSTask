//
//  DetailsVC.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import UIKit
import MessageUI

class DetailsVC: UIViewController, MFMailComposeViewControllerDelegate, ImageActivity, UITableViewDelegate {

    let mail = Mail()
    var detailsViewModel: DetailsViewModel!
    var mainViewModel: MainViewModel!
    
    var dataSource: DetailsTableViewDataSource?
    
    var userID = Int()
    
    @IBOutlet weak var tableView: UITableView!
    
    var imageViewData = Data()
    
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            //self.infoView.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsViewModel = DetailsViewModel()
        mainViewModel = MainViewModel()
        
        delegatesInit()
        designInit()
        
        detailsViewModel.getImage(userID: 1) //PADUOTI USER ID
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
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Delegates init
    func delegatesInit() {
        tableView.delegate = self
        
        mail.delegate = self
    }
    
    func selectedCell(row: Int) {
        print(row)
    }
    
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
}
