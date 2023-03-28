//
//  JourDTO.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation

struct JourDTO: Codable {
    
    var _id: String?
    var nom: String
    var date: Date
    var debutHeure: Date
    var finHeure: Date
    var idFestival: String
    
    internal init(_id: String? = nil, nom: String, date: Date, debutHeure: Date, finHeure: Date, idFestival: String) {
        self._id = _id
        self.nom = nom
        self.date = date
        self.debutHeure = debutHeure
        self.finHeure = finHeure
        self.idFestival = idFestival
    }
    
}
