//
//  FetchData.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import Foundation

class FetchPosts {
    
    /// Fetch posts
    func getPosts(completion: @escaping (Bool, Posts?, String?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")! as URL, timeoutInterval: 5.0)
        
        request.httpMethod = "GET"
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            //Network request to API
            let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                //Request error
                if error != nil {
                    completion(false, nil, error?.localizedDescription)
                    print(error?.localizedDescription ?? "Error")
                    return
                }
                
                //Response code
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
                
                if data != nil {
                    //Returning API value
                    if let data = data {
                        do {
                            let posts = try JSONDecoder().decode(Posts.self, from: data)
                            
                            completion(true, posts, nil)
                            
                        } catch let error {
                            //Parsing error
                            completion(false, nil, error.localizedDescription)
                            print(error.localizedDescription)
                        }
                    }
                    
                }
            })
            dataTask.resume()
        }
    }
}

