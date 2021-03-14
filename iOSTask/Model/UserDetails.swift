//
//  UserDetails.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import Foundation

// MARK: - UserDetails
struct UserDetailsStruct: Codable {
    let id: Int
    let name, username, email: String
    let address: AddressStruct
    let phone, website: String
    let company: CompanyStruct
}

typealias UsersDetails = [UserDetailsStruct]

// MARK: - Address
struct AddressStruct: Codable {
    let street, suite, city, zipcode: String
    let geo: GeoStruct
}

// MARK: - Geo
struct GeoStruct: Codable {
    let lat, lng: String
}

// MARK: - Company
struct CompanyStruct: Codable {
    let name, catchPhrase, bs: String
}
