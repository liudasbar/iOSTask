//  iOSTask
//
//  Created by LiudasBar on 2021-03-14.
//

import Foundation
import CoreData

extension DetailsViewModel {
    /// Retrieve database user details
    func retrieveDatabaseUserDetails(userID: Int) {
        do {
            let usersDetailsEntity = try self.postsContext.fetch(UserDetails.fetchRequest())
            
            //Iterate through all posts in database
            for userDetails in usersDetailsEntity as! [UserDetails] {
                
                let userIDDB = Int(userDetails.id)
                let name = userDetails.name!
                let username = userDetails.username!
                let email = userDetails.email!
                let phone = userDetails.phone!
                let website = userDetails.website!
                let city = userDetails.addressCity!
                let street = userDetails.addressStreet!
                let zipcode = userDetails.addressZipcode!
                let suite = userDetails.addressSuite!
                let lat = userDetails.addressGeoLat!
                let lng = userDetails.addressGeoLng!
                let companyName = userDetails.companyName!
                let bs = userDetails.companyBs!
                let catchPhrase = userDetails.companyCatchPhrase!
                
                if userID == userIDDB {
                    self.userData.value = UserDetailsStruct(id: userID, name: name, username: username, email: email, address: AddressStruct(street: street, suite: suite, city: city, zipcode: zipcode, geo: GeoStruct(lat: lat, lng: lng)), phone: phone, website: website, company: CompanyStruct(name: companyName, catchPhrase: catchPhrase, bs: bs))
                }
            }
            
        } catch let error {
            self.delegate?.showError(title: "Error loading user data from database", message: "Reason: \(error.localizedDescription)")
        }
    }
}
