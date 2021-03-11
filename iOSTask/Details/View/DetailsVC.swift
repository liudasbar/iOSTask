//
//  DetailsVC.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import UIKit
import MessageUI

class DetailsVC: UIViewController, MFMailComposeViewControllerDelegate, ImageActivity {

    let mail = Mail()
    var detailsViewModel: DetailsViewModel!
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    //Email button
    @IBOutlet weak var emailButton: UIButton!
    @IBAction func emailButtonAction(_ sender: UIButton) {
        mail.sendMail(sender.title(for: .normal)!)
    }
    
    @IBOutlet weak var locationButton: UIButton!
    @IBAction func locationButtonAction(_ sender: UIButton) {
        launchGoogleMaps(String(), String()) //ADD REAL COORDINATES
    }
    
    //Call button
    @IBOutlet weak var callButton: UIButton!
    @IBAction func callButtonAction(_ sender: UIButton) {
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsViewModel = DetailsViewModel()
        
        delegatesInit()
        designInit()
        
        detailsViewModel.getImage(userID: 1) //PADUOTI USER ID
    }
    
    
    /// Design init
    func designInit() {
        infoView.alpha = 0
        
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
    }
    
    /// Delegates init
    func delegatesInit() {
        mail.delegate = self
    }
    
    /// Load image onto the imageView
    func loadImage(imageData: Data) {
        imageView.image = UIImage(data: imageData)
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
