//
//  FetchUserData.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-11.
//

import Foundation

class FetchUserData {
    
    /// Fetch posts
    func getUserData(userID: Int, completion: @escaping (Bool, UserDetails?, String?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/users/\(userID)")! as URL, timeoutInterval: 5.0)
        
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
                
                if data != nil {
                    //Returning API value
                    if let data = data {
                        do {
                            let user = try JSONDecoder().decode(UserDetails.self, from: data)
                            
                            completion(true, user, nil)
                            
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

