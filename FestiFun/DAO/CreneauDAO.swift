//
//  CreneauDAO.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation

struct CreneauDAO {
    
    static var shared: CreneauDAO = {
        return CreneauDAO()
    }()
    
    private init() {}
    
    func getAllCreneau() async -> Result<[Creneau], Error> {
        do {
            // recupere tout les creneaux de la base de donnee et les transforment en CreneauDTO
            let decoded : [CreneauDTO] = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "creneau")
            debugPrint(decoded)
            // dans une boucle transformer chaque CreneauDTO en model Creneau
            var creneaux: [Creneau] = []
            for creneauDTO in decoded {
                creneaux.append(getCreneauFromCreneauDTO(creneauDTO: creneauDTO))
            }

            // retourner une liste de Creneau
            return .success(creneaux)
            
        } catch {
            print("Error while fetching creneaux from backend: \(error)")
            return .failure(error)
        }
        
    }
    
    func getCreneauById(id: String) async -> Result<Creneau, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let creneauDTO : CreneauDTO = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "creneau/\(id)")
            
            // retourner un Result avec creneau ou error
            return .success(getCreneauFromCreneauDTO(creneauDTO: creneauDTO))
            
        } catch {
            print("Error while fetching creneau from backend: \(error)")
            return .failure(error)
        }
    }
    
    func createCreneau(creneau: Creneau) async -> Result<Creneau, Error> {
        let creneauDTO = getCreneauDTOFromCreneau(creneau: creneau)
        do {
            let decoded : CreneauDTO = try await URLSession.shared.create(from: FestiFunApp.apiUrl + "creneau/", object: creneauDTO)
            return .success(getCreneauFromCreneauDTO(creneauDTO: decoded))
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    }
    
    func deleteCreneauById(_ id: String) async -> Result<Bool, Error> {
        do {
            let deleted: Bool = try await URLSession.shared.delete(from: FestiFunApp.apiUrl + "creneau/\(id)")
            return .success(deleted)
        } catch {
            return .failure(error)
        }
    }
    
    private func getCreneauDTOFromCreneau(creneau : Creneau) ->CreneauDTO {
        let creneauDTO = CreneauDTO(
            heureDebut: creneau.heureDebut,
            heureFin: creneau.heureFin,
            idJour: creneau.idJour
        )
        
        return creneauDTO
    }
    
    private func getCreneauFromCreneauDTO(creneauDTO : CreneauDTO) -> Creneau {
        let creneau = Creneau(
            heureDebut: creneauDTO.heureDebut,
            heureFin: creneauDTO.heureFin,
            idJour: creneauDTO.idJour
        )
        
        return creneau
    }
}

