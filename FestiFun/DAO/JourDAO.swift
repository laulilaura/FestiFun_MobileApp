//
//  JourDAO.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation

struct JourDAO {
    
    static var shared: JourDAO = {
        return JourDAO()
    }()
    
    private init() {}
    
    func getAllJour() async -> Result<[Jour], Error> {
        do {
            // recupere tout les jours de la base de donnee et les transforment en JourDTO
            let decoded : [JourDTO] = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "jour")
            debugPrint(decoded)
            // dans une boucle transformer chaque JourDTO en model Jour
            var jours: [Jour] = []
            for jourDTO in decoded {
                jours.append(getJourFromJourDTO(jourDTO: jourDTO))
            }

            // retourner une liste de Jour
            return .success(jours)
            
        } catch {
            print("Error while fetching jour from backend: \(error)")
            return .failure(error)
        }
        
    }
    
    func getJourById(id: String) async -> Result<Jour, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let jourDTO : JourDTO = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "jour/\(id)")
            
            // retourner un Result avec jour ou error
            return .success(getJourFromJourDTO(jourDTO: jourDTO))
            
        } catch {
            print("Error while fetching jour from backend: \(error)")
            return .failure(error)
        }
    }
    
    func getJoursByFestival(id: String) async -> Result<[Jour], Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let decoded : [JourDTO] = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "jour/joursByFestival/\(id)")
            
            // dans une boucle transformer chaque JourDTO en model Jour
            var jours: [Jour] = []
            for jourDTO in decoded {
                jours.append(getJourFromJourDTO(jourDTO: jourDTO))
            }
            
            // retourner un Result avec jour ou error
            return .success(jours)
            
        } catch {
            print("Error while fetching jour from backend: \(error)")
            return .failure(error)
        }
    }
    
    func createJour(jour: Jour) async -> Result<Jour, Error> {
        let jourDTO = getJourDTOFromJour(jour: jour)
        do {
            let decoded : JourDTO = try await URLSession.shared.create(from: FestiFunApp.apiUrl + "jour/", object: jourDTO)
            return .success(getJourFromJourDTO(jourDTO: decoded))
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    }
    
    func updateJour(jourVM: JourFormViewModel) async -> Result<Jour, Error> {
        guard jourVM.id != nil else {
            return .failure(UndefinedError.error("Le jour ne possède pas d'id"))
        }
        
        let jourDTO = getJourDTOFromJourVM(jourVM: jourVM)
        do {
            let decoded : JourDTO = try await URLSession.shared.update(from: FestiFunApp.apiUrl + "jour\(jourVM.id!)/", object: jourDTO)
            return .success(getJourFromJourDTO(jourDTO: decoded))
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    }
    
    func deleteJourById(_ id: String) async -> Result<Bool, Error> {
        do {
            let deleted: Bool = try await URLSession.shared.delete(from: FestiFunApp.apiUrl + "jour/\(id)")
            return .success(deleted)
        } catch {
            return .failure(error)
        }
    }
    
    private func getJourDTOFromJour(jour : Jour) -> JourDTO {
        let jourDTO = JourDTO(
            _id: jour.id,
            nom: jour.nom,
            date: jour.date,
            debutHeure: jour.debutHeure,
            finHeure: jour.finHeure,
            idFestival: jour.idFestival)
        return jourDTO
    }
    
    private func getJourFromJourDTO(jourDTO : JourDTO) -> Jour {
        let jour = Jour(
            id: jourDTO._id,
            nom: jourDTO.nom,
            date: jourDTO.date,
            debutHeure: jourDTO.debutHeure,
            finHeure: jourDTO.finHeure,
            idFestival: jourDTO.idFestival )
        return jour
    }
    
    private func getJourDTOFromJourVM(jourVM: JourFormViewModel) -> JourDTO {
        let jourDTO = JourDTO(
            nom: jourVM.nom,
            date: jourVM.date,
            debutHeure: jourVM.debutHeure,
            finHeure: jourVM.finHeure,
            idFestival: jourVM.idFestival
        )
        
        return jourDTO
    }
}

