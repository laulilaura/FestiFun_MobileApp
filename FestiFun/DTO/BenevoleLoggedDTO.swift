//
//  TestDTO.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

struct BenevoleLoggedDTO: Codable {
    
    var id: String?
    var nom: String
    var prenom: String
    var email: String
    var isAdmin: Bool
    
    internal init(id: String? = nil, nom: String, prenom: String, email: String, isAdmin: Bool) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.isAdmin = isAdmin
    }
    
}
