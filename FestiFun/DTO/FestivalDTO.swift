//
//  FestivalDTO.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import Foundation

struct FestivalDTO: Codable {
    
    var _id: String?
    var nom: String
    var annee: String
    var nbrJours: Int
    var idBenevoles: [String]
    var isClosed: Bool
}
