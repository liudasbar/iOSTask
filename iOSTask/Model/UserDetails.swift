//
//  UserDetails.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import Foundation

/// User details model
struct UserDetailsStruct: Codable {
    let id: Int
    let name, username, email: String
    let address: AddressStruct
    let phone, website: String
    let company: CompanyStruct
}

typealias UsersDetails = [UserDetailsStruct]

/// Address (parent of UserDetailsStruct) model
struct AddressStruct: Codable {
    let street, suite, city, zipcode: String
    let geo: GeoStruct
}

/// Geo (parent of AddressStruct) model
struct GeoStruct: Codable {
    let lat, lng: String
}

/// Company (parent of UserDetailsStruct) model
struct CompanyStruct: Codable {
    let name, catchPhrase, bs: String
}
