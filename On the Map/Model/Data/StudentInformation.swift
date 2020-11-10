//
//  StudentInformation.swift
//  On the Map
//
//  Created by Ivan Zandonà on 07/11/2020.
//

import Foundation

struct StudentInformation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectID: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case longitude
        case latitude
        case mapString
        case mediaURL
        case uniqueKey
        case objectID = "objectId"
        case createdAt
        case updatedAt
    }
}
