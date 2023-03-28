//
//  AffectationDTO.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation

struct AffectationDTO: Codable {
    
    var id: String?
    var idBenevoles: [String]
    var idCreneau: String
    var idZone: String
    var idFestival: String
    
}
