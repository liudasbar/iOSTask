//
//  SendMail.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import Foundation
import MessageUI

extension DetailsVC {
    
    /// Send mail execution function
    func sendMail(_ type: String) {
        let deviceName = UIDevice.current.localizedModel
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let appBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let screenWidth = Int(UIScreen.main.nativeBounds.width)
        let screenHeight = Int(UIScreen.main.nativeBounds.height)
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["me@liudasbar.dev"])
            mail.setSubject("\(type): Network Lantern")
            mail.setMessageBody("\n\n\nPlease add relevant screenshots via attachments.\n\nDevice: \(deviceName)\nSystem: \(systemName), \(systemVersion)\nApp Version: \(appVersion!)\nBuild Number: \(appBuildNumber!)\nScreen Size: \(screenWidth)x\(screenHeight)", isHTML: false)
            
            self.present(mail, animated: true)
            
        } else {
            let errorAlert = UIAlertController(title: "Email can not be sent", message: "Mail application is probably not set up.", preferredStyle: .alert)
            self.present(errorAlert, animated: true, completion: nil)
            
            errorAlert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: { action in
                return
            }))
        }
    }
    
    /// Mail and all other related child view controllers dismissal when finished
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        controller.dismiss(animated: true)
    }
}
