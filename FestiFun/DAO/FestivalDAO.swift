//
//  FestivalDAO.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import Foundation

struct FestivalDAO {
    
    static var shared: FestivalDAO = {
        return FestivalDAO()
    }()
    
    private init() {}
    
    func getAllFestival() async -> Result<[Festival], Error> {
        do {
            // recupere tout les festivals de la base de donnee et les transforment en FestivalDTO
            let decoded : [FestivalDTO] = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "festival")
            debugPrint(decoded)
            // dans une boucle transformer chaque FestivalDTO en model Festival
            var festivals: [Festival] = []
            for festivalDTO in decoded {
                festivals.append(getFestivalFromFestivalDTO(festivalDTO: festivalDTO))
            }

            // retourner une liste de Festival
            return .success(festivals)
            
        } catch {
            print("Error while fetching festivals from backend: \(error)")
            return .failure(error)
        }
        
    }
    
    func getFestivalById(id: String) async -> Result<Festival, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let festivalDTO : FestivalDTO = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "festival/\(id)")
            
            // retourner un Result avec festival ou error
            return .success(getFestivalFromFestivalDTO(festivalDTO: festivalDTO))
            
        } catch {
            print("Error while fetching festival from backend: \(error)")
            return .failure(error)
        }
    }
    
    func createFestival(festival: Festival) async -> Result<Festival, Error> {
        let festivalDTO = getFestivalDTOFromFestival(festival: festival)
        do {
            let decoded : FestivalDTO = try await URLSession.shared.create(from: FestiFunApp.apiUrl + "festival/", object: festivalDTO)
            return .success(getFestivalFromFestivalDTO(festivalDTO: decoded))
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    }
    
    func deleteFestivalById(_ id: String) async -> Result<Bool, Error> {
        do {
            let deleted: Bool = try await URLSession.shared.delete(from: FestiFunApp.apiUrl + "festival/\(id)")
            return .success(deleted)
        } catch {
            return .failure(error)
        }
    }
    
    private func getFestivalDTOFromFestival(festival : Festival) ->FestivalDTO {
        let festivalDTO = FestivalDTO(
            _id: festival.id!,
            nom: festival.nom,
            annee: festival.annee,
            nbrJours: festival.nbrJours,
            idBenevoles: festival.idBenevoles,
            isClosed: festival.isClosed )
        
        return festivalDTO
    }
    
    private func getFestivalFromFestivalDTO(festivalDTO : FestivalDTO) -> Festival {
        let festival = Festival(
            id: festivalDTO._id,
            nom: festivalDTO.nom,
            annee: festivalDTO.annee,
            nbrJours: festivalDTO.nbrJours,
            idBenevoles: festivalDTO.idBenevoles,
            isClosed: festivalDTO.isClosed )
        
        return festival
    }
}

