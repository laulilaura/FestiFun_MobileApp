//
//  Creneau.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation

protocol CreneauObserver {
    
    func changed(nom: String)
    func changed(heureDebut: Date)
    func changed(heureFin: Date)
    func changed(idJour: String)
}

class Creneau: Identifiable, Comparable {
    
    var observer: CreneauObserver?
    
    var id: String?
    var nom: String {
        didSet {
            self.observer?.changed(nom: self.nom) // this call makes possible observer to observe
        }
    }
    var heureDebut: Date {
        didSet {
            self.observer?.changed(heureDebut: self.heureDebut) // this call makes possible observer to observe
        }
    }
    var heureFin: Date {
        didSet {
            self.observer?.changed(heureFin: self.heureFin) // this call makes possible observer to observe
        }
    }
    var idJour: String {
        didSet {
            self.observer?.changed(idJour: self.idJour) // this call makes possible observer to observe
        }
    }

    internal init(id: String? = nil, nom: String, heureDebut: Date, heureFin: Date, idJour: String) {
        self.id = id
        self.nom = nom
        self.heureDebut = heureDebut
        self.heureFin = heureFin
        self.idJour = idJour
    }

    
    static func == (lhs: Creneau, rhs: Creneau) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    static func < (lhs: Creneau, rhs: Creneau) -> Bool {
        return lhs.id < rhs.id
    }
    
}
