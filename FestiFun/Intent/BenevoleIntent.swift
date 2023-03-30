//
//  BenevoleIntent.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation
import Combine

enum BenevoleFormIntentState {
    case ready
    case loading
    case nomChanging(String)
    case prenomChanging(String)
    case emailChanging(String)
    case passwordChanging(String)
    case isAdminChanging(Bool)
    case benevoleUpdatedInDatabase
    case error(String)
}

enum BenevoleListIntentState {
    case uptodate
    case loading
    case addingBenevole(LoggedBenevole)
    case deletingBenevole(Int)
    case gettingBenevole([LoggedBenevole])
    case error(String)
}

struct BenevoleIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    private var formState = PassthroughSubject<BenevoleFormIntentState, Never>()
    private var listState = PassthroughSubject<BenevoleListIntentState, Never>()
    
    func addObserver(benevoleFormViewModel: BenevoleFormViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.formState.subscribe(benevoleFormViewModel)
    }
    
    func addObserver(benevoleListViewModel: BenevoleListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(benevoleListViewModel)
    }
    
    // MARK: intentToChange functions
    
    func intentToChange(nom: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nomChanging(nom)) // emits an object of type IntentState
    }
    
    func intentToChange(prenom: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.prenomChanging(prenom)) // emits an object of type IntentState
    }
    
    func intentToChange(email: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.emailChanging(email)) // emits an object of type IntentState
    }
    
    func intentToChange(password: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.passwordChanging(password)) // emits an object of type IntentState
    }
    
    func intentToChange(isAdmin: Bool) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.isAdminChanging(isAdmin)) // emits an object of type IntentState
    }
    
    func intentToCreate(benevole: Benevole) async {
        self.formState.send(.loading)
        self.listState.send(.loading)
        if isBenevoleValid(benevole: benevole) {
            switch await BenevoleDAO.shared.registerBenevole(benevole: benevole) {
            case .failure(let error):
                self.formState.send(.error("\(error.localizedDescription)"))
                break
            case .success(let benevole):
                // si ça a marché : modifier le view model et le model
                self.formState.send(.benevoleUpdatedInDatabase)
                self.listState.send(.addingBenevole(benevole))
            }
        }
    }
    
    func intentToDelete(benevoleId id: String, benevoleIndex: Int) async {
        self.formState.send(.loading)
        self.listState.send(.loading)
        switch await BenevoleDAO.shared.deleteBenevoleById(id) {
        case .failure(let error):
            self.listState.send(.error("Error while deleting benevole \(id): \(error.localizedDescription)"))
        case .success:
            self.listState.send(.deletingBenevole(benevoleIndex))
        }
    }
    
    func intentToGetAll() async {
        self.listState.send(.loading)
        self.formState.send(.loading)
        switch await BenevoleDAO.shared.getAllBenevole() {
        case .failure(let error):
            self.formState.send(.error("Erreur : \(error.localizedDescription)"))
        case .success(let benevoles):
            self.listState.send(.gettingBenevole(benevoles))
        }
    }
    
    private func isBenevoleValid(benevole: Benevole) -> Bool {
        if benevole.nom == "" {
            self.formState.send(.error("Name cannot be empty"))
            return false
        } else if benevole.email == "" {
            // TODO: ajouter fonction avec regexp pour le mail
            
            self.formState.send(.error("Email cannot be empty"))
            return false
        } else if benevole.password == "" {
            self.formState.send(.error("Password cannot be empty"))
            return false
        } else {
            return true
        }
    }
    
}
