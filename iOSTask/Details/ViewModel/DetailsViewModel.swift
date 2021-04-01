//  iOSTask
//
//  Created by LiudasBar on 2021-03-11.
//

import Foundation
import Hanson

protocol APIActivity {
    func showError(title: String, message: String)
    func stopRefresh()
}

class DetailsViewModel: NSObject {
    
    let postsContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let userDetailsContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var imageAPI: FetchDetailsImage!
    var userAPI: FetchUserData!
    var postAPI: FetchDetailsPost!
    var mainViewModel: MainViewModel!
    var delegate: APIActivity?
    
    var postData = Observable(PostStruct(userID: 0, id: 0, title: "", body: ""))
    var userData = Observable(UserDetailsStruct(id: 0, name: "", username: "", email: "", address: AddressStruct(street: "", suite: "", city: "", zipcode: "", geo: GeoStruct(lat: "", lng: "")), phone: "", website: "", company: CompanyStruct(name: "", catchPhrase: "", bs: "")))
    var imageData = Observable(Data())
    
    override init() {
        super.init()
        
        imageAPI = FetchDetailsImage()
        userAPI = FetchUserData()
        postAPI = FetchDetailsPost()
        mainViewModel = MainViewModel()
    }
}

