//
//  mappingTestJSON.swift
//  mappingTestJSON
//
//  Created by LiudasBar on 2021-03-15.
//

import XCTest
@testable import iOSTask

var userDetailsStruct: UserDetailsStruct?
var postStruct: PostStruct?
var fetchUserData: FetchUserData?

class MappingTestJSON: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
        
        userDetailsStruct = UserDetailsStruct(id: 0, name: "", username: "", email: "", address: AddressStruct(street: "", suite: "", city: "", zipcode: "", geo: GeoStruct(lat: "", lng: "")), phone: "", website: "", company: CompanyStruct(name: "", catchPhrase: "", bs: ""))
        postStruct = PostStruct(userID: 0, id: 0, title: "", body: "")
        
        fetchUserData = FetchUserData()
    }

    override func tearDownWithError() throws {
        userDetailsStruct = nil
        postStruct = nil
        fetchUserData = nil
        
        super.tearDown()
    }
    
    /// Test JSON mapping for UserDetails
    func testUserDetailsJSONMapping() throws {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "userDetails", withExtension: "json") else {
            XCTFail("Missing file: userDetails.json")
            return
        }
        
        let json = try Data(contentsOf: url)
        let userDetails = try JSONDecoder().decode(UserDetailsStruct.self, from: json)
        
        XCTAssertEqual(userDetails.name, "Leanne Graham")
        XCTAssertEqual(userDetails.address.zipcode, "92998-3874")
        XCTAssertEqual(userDetails.address.geo.lat, "-37.3159")
        XCTAssertEqual(userDetails.phone, "1-770-736-8031 x56442")
        XCTAssertEqual(userDetails.company.name, "Romaguera-Crona")
    }
    
    /// Test JSON mapping for Post
    func testPostJSONMapping() throws {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "postDetails", withExtension: "json") else {
            XCTFail("Missing file: postDetails.json")
            return
        }
        
        let json = try Data(contentsOf: url)
        let postDetails = try JSONDecoder().decode(PostStruct.self, from: json)
        
        XCTAssertEqual(postDetails.userID, 1)
        XCTAssertEqual(postDetails.id, 1)
        XCTAssertEqual(postDetails.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        XCTAssertEqual(postDetails.body, "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
    }
}
