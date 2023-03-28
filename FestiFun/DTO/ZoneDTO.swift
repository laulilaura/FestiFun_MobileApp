//
//  ZoneDTO.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation

struct ZoneDTO: Codable {
    
    var _id: String?
    var nom: String
    var nbBenevolesNecessaires: Int
    var nbBenevolesActuels: Int
    var idFestival: String
    
    internal init(_id: String? = nil, nom: String, nbBenevolesNecessaires: Int, nbBenevolesActuels: Int, idFestival: String) {
        self._id = _id
        self.nom = nom
        self.nbBenevolesNecessaires = nbBenevolesNecessaires
        self.nbBenevolesActuels = nbBenevolesActuels
        self.idFestival = idFestival
    }
    
}
