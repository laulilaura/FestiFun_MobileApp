//
//  URLError.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

enum URLError: Error, CustomStringConvertible {
    
    case failedInit

    public var description: String {
        switch self {
        case .failedInit:
            return "Error while creating url from string"
        }
    }
}
