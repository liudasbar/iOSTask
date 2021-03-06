//  iOSTask
//
//  Created by LiudasBar on 2021-03-14.
//

import Foundation
import CoreData

extension MainViewModel {
    /// Remove all existing Core Data posts
    func removeDatabasePosts() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.postsContext.execute(deleteRequest)
            try self.postsContext.save()
            
        } catch let error {
            self.delegate?.showError(title: "Error deleting database posts data", message: "Reason: \(error.localizedDescription)")
        }
    }
    
    /// Save Core Data posts
    func saveDatabasePosts() {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = postsContext
        
        //Iterate through all posts
        for postData in self.postsData.value {
            
            //Create object in the context
            let postObject = Post(context: privateMOC)
            
            //Save each post data to database
            postObject.id = Int64(postData.id)
            postObject.userID = Int64(postData.userID)
            postObject.title = postData.title
            postObject.body = postData.body
        }
        
        do {
            try privateMOC.save()
            
        } catch let error {
            self.delegate?.showError(title: "Error saving posts data to offline database", message: "Reason: \(error.localizedDescription)")
        }
    }
    
    /// Retrieve Core Data posts
    func retrieveDatabasePosts() {
        do {
            let postsEntity = try self.postsContext.fetch(Post.fetchRequest())
            
            //Iterate through all posts in database
            for post in postsEntity as! [Post] {
                
                let userID = Int(post.userID)
                let postID = Int(post.id)
                let title = post.title
                let body = post.body
                
                //Append database post data to postsData array
                self.postsData.value.append(PostStruct(userID: userID, id: postID, title: title ?? "", body: body ?? ""))
            }
            
        } catch let error {
            self.delegate?.showError(title: "Error loading posts data from database", message: "Reason: \(error.localizedDescription)")
        }
    }
}
