//
//  TokenDTO.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

class TokenDTO : Codable {
    var token: String
    
    init(token: String) {
        self.token = token
    }
}
