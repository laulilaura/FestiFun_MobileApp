//
//  Zone.swift
//  FestiFun
//
//  Created by Laura on 28/03/2023.
//

import Foundation


protocol ZoneObserver {
    
    func changed(nom: String)
    func changed(nbBenevolesNecessaires: Int)
    func changed(nbBenevolesActuels: Int)
    func changed(idFestival: String)
}

class Zone: Identifiable, Comparable {
    
    var observer: ZoneObserver?
    
    var id: String?
    var nom: String {
        didSet {
            self.observer?.changed(nom: self.nom) // this call makes possible observer to observe
        }
    }
    var nbBenevolesNecessaires: Int {
        didSet {
            self.observer?.changed(nbBenevolesNecessaires: self.nbBenevolesNecessaires) // this call makes possible observer to observe
        }
    }
    var nbBenevolesActuels: Int {
        didSet {
            self.observer?.changed(nbBenevolesActuels: self.nbBenevolesActuels) // this call makes possible observer to observe
        }
    }
    var idFestival: String {
        didSet {
            self.observer?.changed(idFestival: self.idFestival) // this call makes possible observer to observe
        }
    }
    
    internal init(id: String? = nil, nom: String, nbBenevolesNecessaires: Int, nbBenevolesActuels: Int, idFestival: String) {
        self.id = id
        self.nom = nom
        self.nbBenevolesNecessaires = nbBenevolesNecessaires
        self.nbBenevolesActuels = nbBenevolesActuels
        self.idFestival = idFestival
    }

    
    static func == (lhs: Zone, rhs: Zone) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    static func < (lhs: Zone, rhs: Zone) -> Bool {
        return lhs.id < rhs.id
    }
    
}
