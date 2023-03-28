//
//  Affectation.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation

protocol AffectationObserver {
    
    func changed(nom: String)
    func changed(idBenevoles: [String])
    func changed(idCreneau: String)
    func changed(idZone: String)
    func changed(idFestival: String)
}

class Affectation: Identifiable, Comparable {
    
    var observer: AffectationObserver?
    
    var id: String?

    var idBenevoles: [String] {
        didSet {
            self.observer?.changed(idBenevoles: self.idBenevoles) // this call makes possible observer to observe
        }
    }
    var idCreneau: String {
        didSet {
            self.observer?.changed(idCreneau: self.idCreneau) // this call makes possible observer to observe
        }
    }
    var idZone: String {
        didSet {
            self.observer?.changed(idZone: self.idZone) // this call makes possible observer to observe
        }
    }
    var idFestival: String {
        didSet {
            self.observer?.changed(idFestival: self.idFestival) // this call makes possible observer to observe
        }
    }

    internal init(id: String? = nil, idBenevoles: [String], idCreneau: String, idZone: String, idFestival: String) {
        self.id = id
        self.idBenevoles = idBenevoles
        self.idCreneau = idCreneau
        self.idZone = idZone
        self.idFestival = idFestival
    }
    
    
    static func == (lhs: Affectation, rhs: Affectation) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    static func < (lhs: Affectation, rhs: Affectation) -> Bool {
        return lhs.id < rhs.id
    }
    
}
