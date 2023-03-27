//
//  LoggedBenevole.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

class LoggedBenevole: Identifiable, ObservableObject {
    
    var id: String?
    @Published var nom: String
    @Published var prenom: String
    @Published var email: String
    @Published var isAdmin: Bool
    @Published var isAuthenticated: Bool
    
    internal init(id: String? = nil, nom: String, prenom: String, email: String, isAdmin: Bool, isAuthenticated: Bool) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.isAdmin = isAdmin
        self.isAuthenticated = isAuthenticated
    }
}
