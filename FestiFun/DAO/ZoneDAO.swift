//
//  ZoneDAO.swift
//  FestiFun
//
//  Created by Laura on 28/03/2023.
//

import Foundation

struct ZoneDAO {
    
    static var shared: ZoneDAO = {
        return ZoneDAO()
    }()
    
    private init() {}
    
    func getAllZone() async -> Result<[Zone], Error> {
        do {
            // recupere tout les Zones de la base de donnee et les transforment en ZoneDTO
            let decoded : [ZoneDTO] = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "Zone")
            debugPrint(decoded)
            // dans une boucle transformer chaque ZoneDTO en model Zone
            var Zones: [Zone] = []
            for ZoneDTO in decoded {
                Zones.append(getZoneFromZoneDTO(ZoneDTO: ZoneDTO))
            }

            // retourner une liste de Zone
            return .success(Zones)
            
        } catch {
            print("Error while fetching Zones from backend: \(error)")
            return .failure(error)
        }
        
    }
    
    func getZoneById(id: String) async -> Result<Zone, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let ZoneDTO : ZoneDTO = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "Zone/\(id)")
            
            // retourner un Result avec Zone ou error
            return .success(getZoneFromZoneDTO(ZoneDTO: ZoneDTO))
            
        } catch {
            print("Error while fetching Zone from backend: \(error)")
            return .failure(error)
        }
    }
    
    func createZone(Zone: Zone) async -> Result<Zone, Error> {
        let ZoneDTO = getZoneDTOFromZone(Zone: Zone)
        do {
            let decoded : ZoneDTO = try await URLSession.shared.create(from: FestiFunApp.apiUrl + "Zone/", object: ZoneDTO)
            return .success(getZoneFromZoneDTO(ZoneDTO: decoded))
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    }
    
    func deleteZoneById(_ id: String) async -> Result<Bool, Error> {
        do {
            let deleted: Bool = try await URLSession.shared.delete(from: FestiFunApp.apiUrl + "Zone/\(id)")
            return .success(deleted)
        } catch {
            return .failure(error)
        }
    }
    
    private func getZoneDTOFromZone(Zone : Zone) -> ZoneDTO {
        let ZoneDTO = ZoneDTO(
            _id: Zone.id!,
            nom: Zone.nom,
            nbBenevolesNecessaires: Zone.nbBenevolesNecessaires,
            nbBenevolesActuels: Zone.nbBenevolesActuels )
        
        return ZoneDTO
    }
    
    private func getZoneFromZoneDTO(ZoneDTO : ZoneDTO) -> Zone {
        let Zone = Zone(
            id: ZoneDTO._id,
            nom: ZoneDTO.nom,
            nbBenevolesNecessaires: ZoneDTO.nbBenevolesNecessaires,
            nbBenevolesActuels: ZoneDTO.nbBenevolesActuels )

        return Zone
    }
}

