//
//  PublicUserDataResponse.swift
//  On the Map
//
//  Created by Ivan Zandonà on 10/11/2020.
//

import Foundation

struct PublicUserDataResponse: Codable {
    let firstName: String?
    let lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
