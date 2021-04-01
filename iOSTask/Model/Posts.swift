//  iOSTask
//
//  Created by LiudasBar on 2021-03-10.
//

import Foundation

/// Post model
struct PostStruct: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

typealias Posts = [PostStruct]

