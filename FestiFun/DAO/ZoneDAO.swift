//
//  ZoneDAO.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation

struct ZoneDAO {
    
    static var shared: ZoneDAO = {
        return ZoneDAO()
    }()
    
    private init() {}
    
    func getAllZone() async -> Result<[Zone], Error> {
        do {
            // recupere tout les festivals de la base de donnee et les transforment en FestivalDTO
            let decoded : [ZoneDTO] = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "zone")
            debugPrint(decoded)
            // dans une boucle transformer chaque FestivalDTO en model Festival
            var zones: [Zone] = []
            for zoneDTO in decoded {
                zones.append(getZoneFromZoneDTO(zoneDTO: zoneDTO))
            }

            // retourner une liste de Festival
            return .success(zones)
            
        } catch {
            print("Error while fetching zone from backend: \(error)")
            return .failure(error)
        }
        
    }
    
    func getZoneById(id: String) async -> Result<Zone, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let zoneDTO : ZoneDTO = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "zone/\(id)")
            
            // retourner un Result avec festival ou error
            return .success(getZoneFromZoneDTO(zoneDTO: zoneDTO))
            
        } catch {
            print("Error while fetching zone from backend: \(error)")
            return .failure(error)
        }
    }
    
    func createZone(zone: Zone) async -> Result<Zone, Error> {
        let zoneDTO = getZoneDTOFromZone(zone: zone)
        do {
            let decoded : ZoneDTO = try await URLSession.shared.create(from: FestiFunApp.apiUrl + "zone/", object: zoneDTO)
            return .success(getZoneFromZoneDTO(zoneDTO: decoded))
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    }
    
    func deleteZoneById(_ id: String) async -> Result<Bool, Error> {
        do {
            let deleted: Bool = try await URLSession.shared.delete(from: FestiFunApp.apiUrl + "zone/\(id)")
            return .success(deleted)
        } catch {
            return .failure(error)
        }
    }
    
    private func getZoneDTOFromZone(zone : Zone) -> ZoneDTO {
        let zoneDTO = ZoneDTO(
            _id: zone.id!,
            nom: zone.nom,
            nbBenevolesNecessaires: zone.nbBenevolesNecessaires,
            nbBenevolesActuels: zone.nbBenevolesActuels,
            idFestival: zone.idFestival)
        return zoneDTO
    }
    
    private func getZoneFromZoneDTO(zoneDTO : ZoneDTO) -> Zone {
        let zone = Zone(
            id: zoneDTO._id,
            nom: zoneDTO.nom,
            nbBenevolesNecessaires: zoneDTO.nbBenevolesNecessaires,
            nbBenevolesActuels: zoneDTO.nbBenevolesActuels,
            idFestival: zoneDTO.idFestival)
        return zone
    }
}

