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
    
    let postsContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let userDetailsContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var postsAPI: FetchPosts!
    var userDetailsAPI: FetchUserData!
    var delegate: Activity?
    
    var postsData = Observable([PostStruct]())
    var usersData = Observable([UserDetailsStruct]())
    
    override init() {
        super.init()
        
        postsAPI = FetchPosts()
        userDetailsAPI = FetchUserData()
    }
}


