//
//  URLSessionExtention.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation
import JWTDecode


extension URLSession {
    
    func get<T: Decodable> (from url: String) async throws -> T {
            guard let url = URL(string: url) else {
                throw URLError.failedInit
            }
            do{
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                // append a value to a field
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                // set (replace) a value to a field
                if let token = KeychainHelper.standard.getJWT() {
                    debugPrint("token")
                    debugPrint(token)
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    debugPrint("Authorization !!!")
                }
                let (data, response) = try await data(for: request)
                            
                let httpresponse = response as! HTTPURLResponse
                if httpresponse.statusCode == 200 {
                    debugPrint("DATA = \(data)")
                    
                    /*let decoder = JSONDecoder() // création d'un décodeur
                    
                    debugPrint("T.self \(T.self)")
                    if let decoded = try? decoder.decode(T.self, from: data) {
                        debugPrint("test \(decoded)")
                    }*/
                    
                 
                    debugPrint("T.self \(T.self)")
                    debugPrint(String(data: data, encoding: .utf8))
                    guard let decoded : T = JSONHelper.decode(data: data) else {
                        debugPrint("erreur là sah plaisir")
                        throw JSONError.decode
                    }
                     
                    return decoded
                    
                }
                else{
                    print("Error \(httpresponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpresponse.statusCode))")
                    throw HttpError.error(httpresponse.statusCode)
                }
            }
            catch{
                throw UndefinedError.error("Error in GET resquest: \(error)")
            }
        }
    
    func update<T: Codable> (from url: String, object: T) async throws -> Bool {
        
        guard let url = URL(string: url) else {
            throw URLError.failedInit
        }
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            // append a value to a field
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // set (replace) a value to a field
            if let token = KeychainHelper.standard.getJWT() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            guard let encoded : Data = JSONHelper.encode(data: object) else {
                throw JSONError.encode
            }
            
            //let sencoded = String(data: encoded, encoding: .utf8)
            
            let (data, response) = try await upload(for: request, from: encoded)
            
            let sdata = String(data: data, encoding: .utf8)!
            // TODO: risque ?
            let httpresponse = response as! HTTPURLResponse
            if httpresponse.statusCode == 200 {
                print("GoRest Result: \(sdata)")

                return true
                
            }
            else{
                print("Error \(httpresponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpresponse.statusCode))")
                throw HttpError.error(httpresponse.statusCode)
            }
        }
        catch{
            throw UndefinedError.error("Error in PATCH resquest: \(error)")
        }
    }
    
    // TODO: factoriser fonction
    func create<T: Codable> (from url: String, object: T) async throws -> T {
        //TODO: factoriser la fonction avec la fonction créate pour éviter la duplication de code
        debugPrint("Dans le URLSessionCreate")
        guard let url = URL(string: url) else {
            throw URLError.failedInit
        }
        do {
            debugPrint(url)
            debugPrint(object)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            // append a value to a field
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // set (replace) a value to a field
            if let token = KeychainHelper.standard.getJWT() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            guard let encoded : Data = JSONHelper.encode(data: object) else {
                throw JSONError.encode
            }
            
            //let sencoded = String(data: encoded, encoding: .utf8)
            
            let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
            let sdata = String(data: data, encoding: .utf8)!
            debugPrint(sdata)
            // TODO: gérer les erreur dans une fonction à part pour la réutiliser
            let httpresponse = response as! HTTPURLResponse
            if httpresponse.statusCode == 201 {
                print("GoRest Result: \(sdata)")
                guard let decoded : T = JSONHelper.decode(data: data) else {
                    throw JSONError.decode
                }
                return decoded
            }
            else{
                print("Error \(httpresponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpresponse.statusCode))")
                throw HttpError.error(httpresponse.statusCode)
            }
        }
        catch{
            throw UndefinedError.error("Error in POST resquest")
        }
    }
    
    func login(credentialsDTO: CredentialsDTO) async throws -> LoggedBenevole {
        guard let url = URL(string: FestiFunApp.apiUrl + "auth/login") else {
            throw URLError.failedInit
        }
        
        do{
            let benevoleLogged : LoggedBenevole = LoggedBenevole(id: "", nom: "", prenom: "", email: "", isAdmin: false, isAuthenticated: false)
            
            var request = URLRequest(url: url)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            guard let encoded = JSONHelper.encode(data: credentialsDTO) else {
                throw JSONError.encode
            }
            
            let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
            debugPrint(String(data: data, encoding: .utf8))
            let httpresponse = response as! HTTPURLResponse
            if httpresponse.statusCode == 201{
                
                guard let decoded : TokenDTO = JSONHelper.decode(data: data) else {
                    throw JSONError.decode
                }

                if(decoded.token != nil){
                    if let decodedJWT = try? decode(jwt: decoded.token) {
                        if let body = decodedJWT.body["user"] as? [String: Any],
                            let userId = body["id"] as? String,
                            let email = body["email"] as? String,
                            let nom = body["nom"] as? String,
                            let prenom = body["prenom"] as? String,
                            let isAdmin = body["isAdmin"] as? Bool {
                            // Les valeurs ont été extraites avec succès, vous pouvez les utiliser ici
                            benevoleLogged.id = userId
                            benevoleLogged.nom = nom
                            benevoleLogged.prenom = prenom
                            benevoleLogged.email = email
                            benevoleLogged.isAdmin = isAdmin
                            benevoleLogged.isAuthenticated = true
                            return benevoleLogged
                        } else {
                            debugPrint("Could not extract user info from JWT")
                            throw HttpError.unauthorized("Could not extract user info from JWT")
                        }
                    } else {
                        debugPrint("Could not decode JWT")
                        throw HttpError.unauthorized("Could not decode JWT")
                    }
                }
            } else if httpresponse.statusCode == 400 {
                throw HttpError.unauthorized("Email or password invalid")
            }
            else{
                print(httpresponse.statusCode)
                throw UndefinedError.error("Error while login")
            }
            return benevoleLogged
        }
        catch(let error){
            throw error
        }
    }
    
    func register(benevoleDTO: BenevoleDTO) async throws -> LoggedBenevole {
        guard let url = URL(string: FestiFunApp.apiUrl + "auth/") else {
            throw URLError.failedInit
        }
        
        do{
            
            var request = URLRequest(url: url)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            guard let encoded = JSONHelper.encode(data: benevoleDTO) else {
                throw JSONError.encode
            }
            
            let (_, response) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let httpresponse = response as! HTTPURLResponse
            if httpresponse.statusCode == 201{
                var connectionBenevole: CredentialsDTO = CredentialsDTO(email: benevoleDTO.email, password: benevoleDTO.password)
                debugPrint("Connection après une inscription\n  Email : \(connectionBenevole.email)\n Password : \(connectionBenevole.password)")
                return try await login(credentialsDTO: connectionBenevole)
            } else if httpresponse.statusCode == 401 {
                throw HttpError.unauthorized("Email or password invalid")
            }
            else{
                print(httpresponse.statusCode)
                throw UndefinedError.error("Error while login")
            }
        }
        catch(let error){
            throw error
        }
    }
    
    func delete(from url: String) async throws -> Bool {
        guard let url = URL(string: url) else {
            throw URLError.failedInit
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = KeychainHelper.standard.getJWT() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
                    
            let (_, response) = try await URLSession.shared.upload(for: request, from: Data())
            let httpresponse = response as! HTTPURLResponse
            if httpresponse.statusCode == 200 {
                return true
            } else if httpresponse.statusCode == 409 {
                throw HttpError.conflict("Conflict in delete")
            } else {
                print("Error \(httpresponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpresponse.statusCode))")
                throw HttpError.error(httpresponse.statusCode)
            }
        } catch {
            throw error
        }
    }
    
}
