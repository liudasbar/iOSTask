//  iOSTask
//
//  Created by LiudasBar on 2021-03-14.
//

import Foundation
import CoreData

extension DetailsViewModel {
    /// Retrieve database post
    func retrieveDatabasePost(postID: Int) {
        do {
            let postsEntity = try self.postsContext.fetch(Post.fetchRequest())
            
            //Iterate through all posts in database
            for post in postsEntity as! [Post] {
                
                let userID = Int(post.userID)
                let postIDDB = Int(post.id)
                let title = post.title
                let body = post.body
                
                if postID == postIDDB {
                    self.postData.value = PostStruct(userID: userID, id: postID, title: title ?? "", body: body ?? "")
                }
            }
            
        } catch let error {
            self.delegate?.showError(title: "Error loading post data from database", message: "Reason: \(error.localizedDescription)")
        }
    }
}
