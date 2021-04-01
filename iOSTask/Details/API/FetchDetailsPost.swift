//  iOSTask
//
//  Created by LiudasBar on 2021-03-13.
//

import Foundation

class FetchDetailsPost {
    
    /// Fetch post
    func getPost(postID: Int, completion: @escaping (Bool, PostStruct?, String?) -> Void) {
        
        let request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/\(postID)")! as URL, timeoutInterval: 5.0)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            //Network request to API
            let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                //Request error
                if error != nil {
                    completion(false, nil, error!.localizedDescription)
                    return
                }
                
                if data != nil {
                    //Returning API value
                    if let data = data {
                        do {
                            let post = try JSONDecoder().decode(PostStruct.self, from: data)
                            
                            completion(true, post, nil)
                            
                        } catch let error {
                            //Parsing error
                            completion(false, nil, error.localizedDescription)
                        }
                    }
                    
                }
            })
            dataTask.resume()
        }
    }
}

