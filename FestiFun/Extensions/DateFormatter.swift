//
//  DateFormatter.swift
//  FestiFun
//
//  Created by etud on 31/03/2023.
//

import Foundation

extension DateFormatter {
    public static var formatDate1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        debugPrint("Formatter ")
        debugPrint(formatter)
        return formatter
    }()
    
    static let customFormat2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }()
}
