//
//  BenevoleDTO.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

struct BenevoleDTO: Identifiable, Codable {
    
    var id: String?
    var nom: String
    var prenom: String
    var email: String
    var password: String
    var isAdmin: Bool
    
    internal init(id: String? = nil, nom: String, prenom: String, email: String, password: String, isAdmin: Bool) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.password = password
        self.isAdmin = isAdmin
    }
    
}
