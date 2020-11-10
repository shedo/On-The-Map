//
//  LoginResponse.swift
//  On the Map
//
//  Created by Ivan Zandonà on 07/11/2020.
//

import Foundation

struct LoginResponse: Codable {
    let account: AccountResponse
    let session: SessionResponse
}
