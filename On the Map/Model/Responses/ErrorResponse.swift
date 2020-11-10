//
//  ErrorResponse.swift
//  On the Map
//
//  Created by Ivan Zandonà on 07/11/2020.
//

import Foundation

struct ErrorResponse: Codable	 {
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
