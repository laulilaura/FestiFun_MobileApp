//
//  CredentialsDTO.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

class CredentialsDTO : Codable {
    var email: String
    var password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
