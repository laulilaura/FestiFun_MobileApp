//
//  FormatterHelper.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

struct FormatterHelper {
    
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumSignificantDigits = 2
        return formatter
    }()
    
    static let intFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()
}
