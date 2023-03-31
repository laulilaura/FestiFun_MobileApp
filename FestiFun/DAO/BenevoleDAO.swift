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
    
    func getAllBenevole() async -> Result<[LoggedBenevole], Error> {
        do {
            // recupere tout les benevoles de la base de donnee et les transforment en BenevoleDTO
            let decoded : [BenevoleLoggedDTO] = try await URLSession.shared.get(from: FestiFunApp.apiUrl + "benevole")
            
            // Transformer chaque BenevoleLoggedDTO de decoded en LoggedBenevole
            var benevoles: [LoggedBenevole] = []
            for benevole in decoded {
                benevoles.append(getLoggedBenevoleFromBenevoleLoggedDTO(benevoleLoggedDTO: benevole))
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
            print("Error while fetching benevole from backend: \(error)")
            return .failure(error)
        }
    }
    
    
    func registerBenevole(benevole: Benevole) async -> Result<LoggedBenevole, Error> {
        debugPrint("dans BenevoleDAORegisterBenevole")
        let benevoleDTO = getBenevoleDTOFromBenevole(benevole: benevole)
        do {
            let decoded : LoggedBenevole = try await URLSession.shared.register(benevoleDTO: benevoleDTO)
            debugPrint("Benevole register : \(decoded)")
            return .success(decoded)
        } catch {
            // on propage l'erreur transmise par la fonction post
            debugPrint(error)
            return .failure(error)
        }
    }
    
    func updateBenevole(benevoleVM: BenevoleFormViewModel) async -> Result<Benevole, Error> {
        guard benevoleVM.id != nil else {
            return .failure(UndefinedError.error("Le bénévole ne possède pas d'id"))
        }
        
        let benevoleDTO = getBenevoleDTOFromBenevoleVM(benevoleVM: benevoleVM)
        do {
            let response : BenevoleDTO = try await URLSession.shared.update(from: FestiFunApp.apiUrl + "benevole/\(benevoleVM.id!)", object: benevoleDTO)
            // TODO: faire comme lucas mettre string jsp .utf8
            debugPrint("Benevole updated : \(response)")
            let decoded: Benevole = getBenevoleFromBenevoleDTO(benevoleDTO: response)
            return .success(decoded)
        } catch {
            // on propage l'erreur transmise par la fonction post
            debugPrint(error)
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
    
    private func getLoggedBenevoleFromBenevoleLoggedDTO(benevoleLoggedDTO : BenevoleLoggedDTO) -> LoggedBenevole {
        let benevole = LoggedBenevole(
            id: benevoleLoggedDTO.id,
            nom: benevoleLoggedDTO.nom,
            prenom: benevoleLoggedDTO.prenom,
            email: benevoleLoggedDTO.email,
            isAdmin: benevoleLoggedDTO.isAdmin,
            isAuthenticated: true)
        
        return benevole
    }
    
    private func getBenevoleDTOFromBenevoleVM(benevoleVM: BenevoleFormViewModel) -> BenevoleDTO {
        let benevoleDTO: BenevoleDTO = BenevoleDTO(
            nom: benevoleVM.nom,
            prenom: benevoleVM.prenom,
            email: benevoleVM.email,
            password: benevoleVM.password,
            isAdmin: benevoleVM.isAdmin
        )
        
        return benevoleDTO
    }
     
}

