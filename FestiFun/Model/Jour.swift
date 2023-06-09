//
//  Jour.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation

protocol JourObserver {
    
    func changed(nom: String)
    func changed(date: String)
    func changed(debutHeure: String)
    func changed(finHeure: String)
    func changed(idFestival: String)
}

class Jour: Identifiable, Comparable {
    
    var observer: JourObserver?
    
    var id: String?
    var nom: String {
        didSet {
            self.observer?.changed(nom: self.nom) // this call makes possible observer to observe
        }
    }
    var date: String {
        didSet {
            self.observer?.changed(date: self.date) // this call makes possible observer to observe
        }
    }
    var debutHeure: String {
        didSet {
            self.observer?.changed(debutHeure: self.debutHeure) // this call makes possible observer to observe
        }
    }
    var finHeure: String {
        didSet {
            self.observer?.changed(finHeure: self.finHeure) // this call makes possible observer to observe
        }
    }
    var idFestival: String {
        didSet {
            self.observer?.changed(idFestival: self.idFestival) // this call makes possible observer to observe
        }
    }
    
    internal init(id: String? = nil, nom: String, date: String, debutHeure: String, finHeure: String, idFestival: String) {
        self.id = id
        self.nom = nom
        self.date = date
        self.debutHeure = debutHeure
        self.finHeure = finHeure
        self.idFestival = idFestival
    }

    
    static func == (lhs: Jour, rhs: Jour) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    static func < (lhs: Jour, rhs: Jour) -> Bool {
        return lhs.id < rhs.id
    }
    
}
