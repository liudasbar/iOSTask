//
//  FetchImage.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-11.
//

import Foundation

class FetchImage {
    
    /// Fetch image
    func getImage(userID: Int, completion: @escaping (Bool, Data?, String?) -> Void) {
        
        let request = URLRequest(url: URL(string: "https://source.unsplash.com/collection/542909/?sig=\(userID)")! as URL, timeoutInterval: 5.0)
        
        DispatchQueue.global(qos: .userInitiated).async {

            //Network request to fetch image
            let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                //Request error
                if error != nil {
                    completion(false, nil, error!.localizedDescription)
                    return
                }
                
                if data != nil {
                    //Return image
                    if let data = data {
                        completion(true, data, nil)
                    }
                }
            })
            dataTask.resume()
        }
    }
}

