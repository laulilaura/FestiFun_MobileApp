//
//  AffectationDAO.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation

struct AffectationDAO {
    
    static var shared: AffectationDAO = {
        return AffectationDAO()
    }()
    
    private init() {}
    
    func getAllAffectation() async -> Result<[Affectation], Error> {
        do {
            // recupere tout les affectations de la base de donnee et les transforment en AffectationDTO
            let decoded : [AffectationDTO] = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "affectation")
            debugPrint(decoded)
            // dans une boucle transformer chaque AffectationDTO en model Affectation
            var affectations: [Affectation] = []
            for affectationDTO in decoded {
                affectations.append(getAffectationFromAffectationDTO(affectationDTO: affectationDTO))
            }

            // retourner une liste de Affectation
            return .success(affectations)
            
        } catch {
            print("Error while fetching affectations from backend: \(error)")
            return .failure(error)
        }
        
    }
    
    func getAffectationById(id: String) async -> Result<Affectation, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let affectationDTO : AffectationDTO = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "affectation/\(id)")
            
            // retourner un Result avec affectation ou error
            return .success(getAffectationFromAffectationDTO(affectationDTO: affectationDTO))
            
        } catch {
            print("Error while fetching affectation from backend: \(error)")
            return .failure(error)
        }
    }
    
    func createAffectation(affectation: Affectation) async -> Result<Affectation, Error> {
        let affectationDTO = getAffectationDTOFromAffectation(affectation: affectation)
        do {
            let decoded : AffectationDTO = try await URLSession.shared.create(from: FestiFunApp.apiUrl + "affectation/", object: affectationDTO)
            return .success(getAffectationFromAffectationDTO(affectationDTO: decoded))
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    }
    
    func deleteAffectationById(_ id: String) async -> Result<Bool, Error> {
        do {
            let deleted: Bool = try await URLSession.shared.delete(from: FestiFunApp.apiUrl + "affectation/\(id)")
            return .success(deleted)
        } catch {
            return .failure(error)
        }
    }
    
    func updateAffectation(affectationVM: AffectationFormViewModel) async -> Result<Affectation, Error> {
        guard affectationVM.id != nil else {
            return .failure(UndefinedError.error("L'affectation ne possède pas d'id"))
        }
        
        do {
            let affectationDTO: AffectationDTO = getAffectationDTOFromAffectationVM(affectationVM: affectationVM)
            let affectationUpdated: AffectationDTO = try await URLSession.shared.update(from: FestiFunApp.apiUrl + "affectation/\(affectationVM.id!)", object: affectationDTO)
            return .success(getAffectationFromAffectationDTO(affectationDTO: affectationUpdated))
        } catch {
            return .failure(error)
        }
    }
    
    private func getAffectationDTOFromAffectation(affectation : Affectation) ->AffectationDTO {
        let affectationDTO = AffectationDTO(
            idBenevoles: affectation.idBenevoles,
            idCreneau: affectation.idCreneau,
            idZone: affectation.idZone,
            idFestival: affectation.idFestival
        )
        
        return affectationDTO
    }
    
    private func getAffectationFromAffectationDTO(affectationDTO : AffectationDTO) -> Affectation {
        let affectation = Affectation(
            idBenevoles: affectationDTO.idBenevoles,
            idCreneau: affectationDTO.idCreneau,
            idZone: affectationDTO.idZone,
            idFestival: affectationDTO.idFestival
        )
        
        return affectation
    }
    
    private func getAffectationDTOFromAffectationVM(affectationVM: AffectationFormViewModel) -> AffectationDTO {
        let affectationDTO = AffectationDTO(
            idBenevoles: affectationVM.idBenevoles,
            idCreneau: affectationVM.idCreneau,
            idZone: affectationVM.idZone,
            idFestival: affectationVM.idFestival
        )
        
        return affectationDTO
    }
}

