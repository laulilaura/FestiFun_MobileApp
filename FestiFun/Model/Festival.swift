//
//  Festival.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import Foundation

protocol FestivalObserver {
    
    func changed(nom: String)
    func changed(annee: String)
    func changed(nbrJours: Int)
    func changed(idBenevoles: [String])
    func changed(isClosed: Bool)
}

class Festival: Identifiable, Comparable {
    
    var observer: FestivalObserver?
    
    var id: String?
    var nom: String {
        didSet {
            self.observer?.changed(nom: self.nom) // this call makes possible observer to observe
        }
    }
    var annee: String {
        didSet {
            self.observer?.changed(annee: self.annee) // this call makes possible observer to observe
        }
    }
    var nbrJours: Int {
        didSet {
            self.observer?.changed(nbrJours: self.nbrJours) // this call makes possible observer to observe
        }
    }
    var idBenevoles: [String] {
        didSet {
            self.observer?.changed(idBenevoles: self.idBenevoles) // this call makes possible observer to observe
        }
    }
    var isClosed: Bool {
        didSet {
            self.observer?.changed(isClosed: self.isClosed) // this call makes possible observer to observe
        }
    }
    
    internal init(id: String? = nil, nom: String, annee: String, nbrJours: Int, idBenevoles: [String], isClosed: Bool) {
        self.id = id
        self.nom = nom
        self.annee = annee
        self.nbrJours = nbrJours
        self.idBenevoles = idBenevoles
        self.isClosed = isClosed
    }

    
    static func == (lhs: Festival, rhs: Festival) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    static func < (lhs: Festival, rhs: Festival) -> Bool {
        return lhs.id < rhs.id
    }
    
}
