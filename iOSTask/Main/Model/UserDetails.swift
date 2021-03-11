//
//  UserDetails.swift
//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import Foundation

// MARK: - UserDetails
struct UserDetails: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

typealias UsersDetails = [UserDetails]

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}
