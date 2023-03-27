//
//  JSONHelper.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

struct JSONHelper{
    
    static func encode<T:Codable> (data : T) -> Data?{
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let json = try? encoder.encode(data)
        
        guard json != nil else {
            print("json is empty")
            return nil
        }
        return json
        
    }
    
    static func decode<T: Decodable>(data: Data) -> T? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let customDateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = dateFormatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
            }
            return date
        }
        
        let decoder = JSONDecoder() // création d'un décodeur
        decoder.dateDecodingStrategy = customDateDecodingStrategy
        if let decoded = try? decoder.decode(T.self, from: data) {
            debugPrint("test \(decoded)")
            return decoded
        }
        return nil
    }
    
    static func decodeWithError<T: Decodable>(data: Data) -> Result<T, Error> {
        do {
            let decoder = JSONDecoder() // création d'un décodeur
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            print("Decode error with type: \(T.self) <<<<<<<<<<<<<<")
            return .failure(error)
        }
    }
}
