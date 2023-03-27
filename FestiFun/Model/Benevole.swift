//
//  Benevole.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation


protocol BenevoleObserver {
    
    func changed(nom: String)
    func changed(prenom: String)
    func changed(email: String)
    func changed(password: String)
    func changed(isAdmin: Bool)
}

class Benevole: Identifiable, Comparable {
    
    var observer: BenevoleObserver?
    
    var id: String?
    var nom: String {
        didSet {
            self.observer?.changed(nom: self.nom) // this call makes possible observer to observe
        }
    }
    var prenom: String {
        didSet {
            self.observer?.changed(prenom: self.prenom) // this call makes possible observer to observe
        }
    }
    var email: String {
        didSet {
            self.observer?.changed(email: self.email) // this call makes possible observer to observe
        }
    }
    var password: String {
        didSet {
            self.observer?.changed(password: self.password) // this call makes possible observer to observe
        }
    }
    var isAdmin: Bool {
        didSet {
            self.observer?.changed(isAdmin: self.isAdmin) // this call makes possible observer to observe
        }
    }
    
    internal init(id: String? = nil, nom: String, prenom: String, email: String, password: String, isAdmin: Bool) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.password = password
        self.isAdmin = isAdmin
    }

    
    static func == (lhs: Benevole, rhs: Benevole) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    static func < (lhs: Benevole, rhs: Benevole) -> Bool {
        return lhs.id < rhs.id
    }
    
}
