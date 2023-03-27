//
//  UndefinedError.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

enum UndefinedError: LocalizedError {
    case error(String)
    
    var description: String {
        switch self {
        case .error(let string):
            return string
        }
    }
    
    var errorDescription: String? {
        return self.description
    }
}
