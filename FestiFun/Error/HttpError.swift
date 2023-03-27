//
//  HttpError.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

enum HttpError: Error {
    case error(Int)
    case conflict(String)
    case unauthorized(String)
}
