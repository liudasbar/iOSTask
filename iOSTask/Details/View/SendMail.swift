//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import Foundation
import MessageUI

class SendMail {
    var delegate: DetailsVC?
    
    /// Send mail execution function
    func sendMail(_ email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = delegate
            mail.setToRecipients([email])
            mail.setSubject("")
            mail.setMessageBody("", isHTML: false)
            
            delegate?.present(mail, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Email could not be sent", message: "Mail application is probably not set up.", preferredStyle: .alert)
            delegate?.present(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { action in }))
        }
    }
}

extension DetailsVC {
    /// Mail controller dismiss
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
