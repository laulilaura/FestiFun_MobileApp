//
//  JSONError.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

enum JSONError: LocalizedError {
    case decode
    case encode
    
    var description: String {
        switch self {
        case .decode:
            return "Error while decoding data"
        case .encode:
            return "Error while encoding object in data"
        }
    }
    
    var errorDescription: String? {
        return self.description
    }
}
