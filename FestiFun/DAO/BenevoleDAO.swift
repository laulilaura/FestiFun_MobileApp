//
//  BenevoleDAO.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

struct BenevoleDAO {
    
    static var shared: BenevoleDAO = {
        return BenevoleDAO()
    }()
    
    private init() {}
    
    func getAllBenevole() async -> Result<[Benevole], Error> {
        do {
            // recupere tout les benevoles de la base de donnee et les transforment en BenevoleDTO
            let decoded : [BenevoleLoggedDTO] = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "benevole")
            // dans une boucle transformer chaque BenevoleDTO en model Benevole
            var benevoles: [Benevole] = []
            for benevoleLoggedDTO in decoded {
                benevoles.append(getBenevoleFromBenevoleLoggedDTO(benevoleLoggedDTO: benevoleLoggedDTO))
            }

            // retourner une liste de Benevole
            return .success(benevoles)
            
        } catch {
            print("Error while fetching benevoles from backend: \(error)")
            return .failure(error)
        }
        
    }
    
    func getBenevoleById(id: String) async -> Result<Benevole, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let benevoleDTO : BenevoleDTO = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "benevole/\(id)")
            
            // retourner un Result avec benevole ou error
            return .success(getBenevoleFromBenevoleDTO(benevoleDTO: benevoleDTO))
            
        } catch {
            print("Error while fetching ingredient from backend: \(error)")
            return .failure(error)
        }
    }
    
    func getProfile() async -> Result<Benevole, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let benevoleDTO : BenevoleDTO = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "benevole/profile")
            
            // retourner un Result avec benevole ou error
            return .success(getBenevoleFromBenevoleDTO(benevoleDTO: benevoleDTO))
            
        } catch {
            print("Error while fetching ingredient from backend: \(error)")
            return .failure(error)
        }
    }
    
    
    func createBenevole(benevole: Benevole) async -> Result<Benevole, Error> {
        let benevoleDTO = getBenevoleDTOFromBenevole(benevole: benevole)
        do { 
            let decoded : BenevoleDTO = try await URLSession.shared.create(from: FestiFunApp.apiUrl + "benevole/", object: benevoleDTO)
            return .success(getBenevoleFromBenevoleDTO(benevoleDTO: decoded))
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    }
    
    func deleteBenevoleById(_ id: String) async -> Result<Bool, Error> {
        do {
            let deleted: Bool = try await URLSession.shared.delete(from: FestiFunApp.apiUrl + "benevole/\(id)")
            return .success(deleted)
        } catch {
            return .failure(error)
        }
    }
    
     func login(email: String, password : String) async -> Result<LoggedBenevole, Error> {
        
        let credentialsDTO = CredentialsDTO(email: email, password: password)
        
        do {
            let decoded: LoggedBenevole = try await URLSession.shared.login(credentialsDTO: credentialsDTO)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
        
    }
    
    private func getBenevoleDTOFromBenevole(benevole : Benevole) ->BenevoleDTO {
        let benevoleDTO = BenevoleDTO(
            id: benevole.id,
            nom: benevole.nom,
            prenom: benevole.prenom,
            email: benevole.email,
            password: benevole.password,
            isAdmin: benevole.isAdmin )
        
        return benevoleDTO
    }
    
    private func getBenevoleFromBenevoleDTO(benevoleDTO : BenevoleDTO) -> Benevole {
        let benevole = Benevole(
            id: benevoleDTO.id,
            nom: benevoleDTO.nom,
            prenom: benevoleDTO.prenom,
            email: benevoleDTO.email,
            password: benevoleDTO.password,
            isAdmin: benevoleDTO.isAdmin )
        
        return benevole
    }
    
    private func getBenevoleFromBenevoleLoggedDTO(benevoleLoggedDTO : BenevoleLoggedDTO) -> Benevole {
        let benevole = Benevole(
            id: benevoleLoggedDTO.id,
            nom: benevoleLoggedDTO.nom,
            prenom: benevoleLoggedDTO.prenom,
            email: benevoleLoggedDTO.email,
            password: "",
            isAdmin: benevoleLoggedDTO.isAdmin )
        
        return benevole
    }
}

