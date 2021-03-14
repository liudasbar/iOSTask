//
//  MainViewModelUsersDetailsDB.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-14.
//

import Foundation
import CoreData

extension MainViewModel {
    /// Remove all existing Core Data users details
    func removeDatabaseUersDetails() {
        
        let fetchRequestUserDetails = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        let deleteRequestUserDetails = NSBatchDeleteRequest(fetchRequest: fetchRequestUserDetails)
        
        privateMOC.parent = context
        
        privateMOC.performAndWait {
            do {
                try self.privateMOC.execute(deleteRequestUserDetails)
                try self.privateMOC.save()
                
            } catch let error {
                self.delegate?.showError(title: "Error deleting database users data", message: "Reason: \(error.localizedDescription)")
            }
        }
        
    }
    
    /// Save Core Data users details
    func saveUsersDetailsPosts() {
        do {
            //Iterate through all posts
            for userDetailsData in self.usersData.value {
                
                //Create object in the context
                let userDetailsObject = UserDetails(context: self.context)
                
                //Save each post data to database
                userDetailsObject.id = Int64(userDetailsData.id)
                userDetailsObject.name = userDetailsData.name
                userDetailsObject.username = userDetailsData.username
                userDetailsObject.email = userDetailsData.email
                userDetailsObject.phone = userDetailsData.phone
                userDetailsObject.website = userDetailsData.website
                userDetailsObject.addressCity = userDetailsData.address.city
                userDetailsObject.addressStreet = userDetailsData.address.street
                userDetailsObject.addressZipcode = userDetailsData.address.zipcode
                userDetailsObject.addressSuite = userDetailsData.address.suite
                userDetailsObject.addressGeoLat = userDetailsData.address.geo.lat
                userDetailsObject.addressGeoLng = userDetailsData.address.geo.lng
                userDetailsObject.companyName = userDetailsData.company.name
                userDetailsObject.companyBs = userDetailsData.company.bs
                userDetailsObject.companyCatchPhrase = userDetailsData.company.catchPhrase
                
                try self.context.save()
            }
            
            
            
        } catch let error {
            self.delegate?.showError(title: "Error saving users data to offline database", message: "Reason: \(error.localizedDescription)")
            print(error)
        }
        
    }
    
    /// Retrieve Core Data users details
    func retrieveDatabaseUsersDetails() {
        do {
            let usersDetailsEntity = try self.context.fetch(UserDetails.fetchRequest())
            
            //Iterate through all posts in database
            for userDetails in usersDetailsEntity as! [UserDetails] {
                
                let userID = Int(userDetails.id)
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
                
                //Append database post data to usersData array
                self.usersData.value.append(UserDetailsStruct(id: userID, name: name, username: username, email: email, address: AddressStruct(street: street, suite: suite, city: city, zipcode: zipcode, geo: GeoStruct(lat: lat, lng: lng)), phone: phone, website: website, company: CompanyStruct(name: companyName, catchPhrase: catchPhrase, bs: bs)))
            }
            
        } catch let error {
            self.delegate?.showError(title: "Error loading posts data from database", message: "Reason: \(error.localizedDescription)")
        }
    }
}
