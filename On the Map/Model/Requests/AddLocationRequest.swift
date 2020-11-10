//
//  AddLocation.swift
//  On the Map
//
//  Created by Ivan Zandonà on 10/11/2020.
//

import Foundation

struct AddLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: String
    let longitude: String
}
