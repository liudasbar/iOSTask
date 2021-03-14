//
//  MainViewModel.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import Foundation
import Hanson
import CoreData

/// Activity indicator protocol
protocol Activity {
    func startRefresh()
    func stopRefresh()
    func showError(title: String, message: String)
}

class MainViewModel: NSObject {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var postsAPI: FetchPosts!
    private var userDetailsAPI: FetchUserData!
    var delegate: Activity?
    
    var postsData = Observable([PostStruct]())
    var usersData = Observable([UserDetailsStruct]())
    
    override init() {
        super.init()
        
        postsAPI = FetchPosts()
        userDetailsAPI = FetchUserData()
    }
    
    /// Get posts data
    func getPosts(pullToRefresh: Bool) {
        self.postsAPI.getPosts { (status, data, errorMessage) in
            
            if pullToRefresh {
                self.delegate?.startRefresh()
            }
            
            //Check connection
            if NetworkReachability().isConnectedToNetwork() {
                if status {
                    //If status is OK - assign API data to postsData
                    self.postsData.value = data!
                    
                    self.removeDatabasePosts()
                    
                    self.saveDatabasePosts()
                    
                    self.getUsersDetails()
                    
                } else {
                    self.delegate?.stopRefresh()
                    self.delegate?.showError(title: "Posts could not be loaded", message: "Error occured. Description: \(String(describing: errorMessage!))")
                }
                
            } else {
                //Network unreachable
                
                //Remove all posts data
                self.postsData.value.removeAll()
                
                self.retrieveDatabasePosts()
                
                self.getUsersDetails()
                
                self.delegate?.stopRefresh()
                self.delegate?.showError(title: "You seem to be offline", message: "Showing offline data. Please reconnect to a network for the newest information.")
            }
        }
    }
    
    /// Get users details data
    func getUsersDetails() {
        //Array of all users IDs
        var userIDs: [Int] = []
        
        for post in postsData.value {
            
            //Append user ID only if it is not present in the array
            if !userIDs.contains(post.userID) {
                userIDs.append(post.userID)
                
                //Network reachable
                self.userDetailsAPI.getUserData(userID: post.userID) { (status, data, errorMessage) in
                    
                    //Check connection
                    if NetworkReachability().isConnectedToNetwork() {
                        if status {
                            //If status is OK - assign API data to usersData
                            self.usersData.value.append(data!)
                            
                            self.removeDatabaseUersDetails()
                            
                            self.saveUsersDetailsPosts()
                            
                            self.delegate?.stopRefresh()
                        } else {
                            self.delegate?.stopRefresh()
                            self.delegate?.showError(title: "User details could not be loaded", message: "Error occured. Description: \(String(describing: errorMessage))")
                        }
                    } else {
                        //Remove all users data
                        self.usersData.value.removeAll()
                        
                        self.retrieveDatabaseUsersDetails()
                    }
                }
            }
        }
    }
    
    
    
    /// Remove all existing Core Data users details
    func removeDatabaseUersDetails() {
        
        let fetchRequestUserDetails = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        let fetchRequestCompany = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        let fetchRequestAddress = NSFetchRequest<NSFetchRequestResult>(entityName: "Address")
        let fetchRequestGeo = NSFetchRequest<NSFetchRequestResult>(entityName: "Geo")
        
        let deleteRequestUserDetails = NSBatchDeleteRequest(fetchRequest: fetchRequestUserDetails)
        let deleteRequestCompany = NSBatchDeleteRequest(fetchRequest: fetchRequestCompany)
        let deleteRequestAddress = NSBatchDeleteRequest(fetchRequest: fetchRequestAddress)
        let deleteRequestGeo = NSBatchDeleteRequest(fetchRequest: fetchRequestGeo)
        
        do {
            try self.context.execute(deleteRequestUserDetails)
            try self.context.execute(deleteRequestCompany)
            try self.context.execute(deleteRequestAddress)
            try self.context.execute(deleteRequestGeo)
            try self.context.save()
            
        } catch let error {
            self.delegate?.showError(title: "Error deleting database data", message: "Reason: \(error.localizedDescription)")
        }
    }
    
    /// Save Core Data users details
    func saveUsersDetailsPosts() {
        do {
            //Create object in the context
            let userDetailsObject = UserDetails(context: self.context)
            
            //Iterate through all posts
            for userDetailsData in self.usersData.value {
                
                //Save each post data to database
                userDetailsObject.id = Int64(userDetailsData.id)
                userDetailsObject.name = userDetailsData.name
                userDetailsObject.username = userDetailsData.username
                userDetailsObject.email = userDetailsData.email
                userDetailsObject.phone = userDetailsData.phone
                userDetailsObject.website = userDetailsData.website
                userDetailsObject.address?.city = userDetailsData.address.city
                userDetailsObject.address?.street = userDetailsData.address.street
                userDetailsObject.address?.zipcode = userDetailsData.address.zipcode
                userDetailsObject.address?.suite = userDetailsData.address.suite
                userDetailsObject.address?.geo?.lat = userDetailsData.address.geo.lat
                userDetailsObject.address?.geo?.lng = userDetailsData.address.geo.lng
                userDetailsObject.company?.companyName = userDetailsData.company.name
                userDetailsObject.company?.bs = userDetailsData.company.bs
                userDetailsObject.company?.catchPhrase = userDetailsData.company.catchPhrase
            }
            
            try self.context.save()
            
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
                let city = userDetails.address!.city!
                let street = userDetails.address!.street!
                let zipcode = userDetails.address!.zipcode!
                let suite = userDetails.address!.suite!
                let lat = userDetails.address!.geo!.lat!
                let lng = userDetails.address!.geo!.lng!
                let companyName = userDetails.company!.name!
                let bs = userDetails.company!.bs!
                let catchPhrase = userDetails.company!.catchPhrase!
                
                //Append database post data to usersData array
                self.usersData.value.append(UserDetailsStruct(id: userID, name: name, username: username, email: email, address: AddressStruct(street: street, suite: suite, city: city, zipcode: zipcode, geo: GeoStruct(lat: lat, lng: lng)), phone: phone, website: website, company: CompanyStruct(name: companyName, catchPhrase: catchPhrase, bs: bs)))
                
                print(self.usersData)
            }
            
        } catch let error {
            self.delegate?.showError(title: "Error loading users data from database", message: "Reason: \(error.localizedDescription)")
        }
    }
    
    
    
    /// Remove all existing Core Data posts
    func removeDatabasePosts() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.context.execute(deleteRequest)
            try self.context.save()
            
        } catch let error {
            self.delegate?.showError(title: "Error deleting database posts data", message: "Reason: \(error.localizedDescription)")
        }
    }
    
    /// Save Core Data posts
    func saveDatabasePosts() {
        do {
            //Iterate through all posts
            for postData in self.postsData.value {
                
                //Create object in the context
                let postObject = Post(context: self.context)
                
                //Save each post data to database
                postObject.id = Int64(postData.id)
                postObject.userID = Int64(postData.userID)
                postObject.title = postData.title
                postObject.body = postData.body
            }
            
            try self.context.save()
            
        } catch let error {
            self.delegate?.showError(title: "Error saving posts data to offline database", message: "Reason: \(error.localizedDescription)")
        }
    }
    
    /// Retrieve Core Data posts
    func retrieveDatabasePosts() {
        do {
            let postsEntity = try self.context.fetch(Post.fetchRequest())
            
            //Iterate through all posts in database
            for post in postsEntity as! [Post] {
                
                let userID = Int(post.userID)
                let postID = Int(post.id)
                let title = post.title
                let body = post.body
                
                //Append database post data to postsData array
                self.postsData.value.append(PostStruct(userID: userID, id: postID, title: title ?? "", body: body ?? ""))
                
                //self.getUsersDetails()
            }
            
        } catch let error {
            self.delegate?.showError(title: "Error loading posts data from database", message: "Reason: \(error.localizedDescription)")
        }
    }
}


