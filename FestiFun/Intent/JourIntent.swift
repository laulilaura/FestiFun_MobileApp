//
//  JourIntent.swift
//  FestiFun
//
//  Created by Laura on 28/03/2023.
//

import Foundation
import Combine

enum JourFormIntentState {
    case ready
    case loading
    case nomChanging(String)
    case dateChanging(Date)
    case debutHeureChanging(Date)
    case finHeureChanging(Date)
    case idFestivalChanging(String)
    case jourUpdatedInDatabase
    case error(String)
}

enum JourListIntentState {
    case uptodate
    case loading
    case addingJour(Jour)
    case deletingJour(Int)
    case gettingJour([Jour])
    case error(String)
}

struct JourIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    private var formState = PassthroughSubject<JourFormIntentState, Never>()
    private var listState = PassthroughSubject<JourListIntentState, Never>()
    
    func addObserver(jourFormViewModel: JourFormViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.formState.subscribe(jourFormViewModel)
    }
    
    func addObserver(jourListViewModel: JourListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(jourListViewModel)
    }
    
    // MARK: intentToChange functions
    
    func intentToChange(nom: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nomChanging(nom)) // emits an object of type IntentState
    }
    
    func intentToChange(date: Date) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.dateChanging(date)) // emits an object of type IntentState
    }

    func intentToChange(debutHeure: Date) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.debutHeureChanging(debutHeure)) // emits an object of type IntentState
    }

    func intentToChange(finHeure: Date) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.finHeureChanging(finHeure)) // emits an object of type IntentState
    }

    func intentToChange(idFestival: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.idFestivalChanging(idFestival)) // emits an object of type IntentState
    }
    
    func intentToCreate(jour: Jour) async {
        self.formState.send(.loading)
        self.listState.send(.loading)
            switch await JourDAO.shared.createJour(jour: jour) {
            case .failure(let error):
                self.formState.send(.error("\(error.localizedDescription)"))
                break
            case .success(let jour):
                // si ça a marché : modifier le view model et le model
                self.formState.send(.jourUpdatedInDatabase)
                self.listState.send(.addingJour(jour))
            }
    }
    
    func intentToDelete(jourId id: String, jourIndex: Int) async {
        self.formState.send(.loading)
        self.listState.send(.loading)
        switch await JourDAO.shared.deleteJourById(id) {
        case .failure(let error):
            self.listState.send(.error("Error while deleting jour \(id): \(error.localizedDescription)"))
        case .success:
            self.listState.send(.deletingJour(jourIndex))
        }
    }
    
    func intentToGetAll() async {
        self.listState.send(.loading)
        self.formState.send(.loading)
        switch await JourDAO.shared.getAllJour() {
        case .failure(let error):
            self.formState.send(.error("Erreur : \(error.localizedDescription)"))
        case .success(let jours):
            self.listState.send(.gettingJour(jours))
        }
    }

}

