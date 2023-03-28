//
//  FestivalIntent.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import Foundation
import Combine

enum FestivalIntentState {
    case ready
    case nomChanging(String)
    case anneeChanging(Date)
    case nbrJoursChanging(Int)
    case idBenevolesChanging([String])
    case isClosedChanging(Bool)
    case festivalUpdatedInDatabase
    case error(String)
}

enum FestivalListIntentState {
    case uptodate
    case addingFestival(Festival)
    case deletingFestival(Int)
    case error(String)
}

struct FestivalIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    private var formState = PassthroughSubject<FestivalIntentState, Never>()
    private var listState = PassthroughSubject<FestivalListIntentState, Never>()
    
    func addObserver(festivalFormViewModel: FestivalViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.formState.subscribe(festivalFormViewModel)
    }
    
    func addObserver(festivalListViewModel: FestivalListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(festivalListViewModel)
    }
    
    // MARK: intentToChange functions
    
    func intentToChange(nom: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nomChanging(nom)) // emits an object of type IntentState
    }
    
    func intentToChange(annee: Date) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.anneeChanging(annee)) // emits an object of type IntentState
    }
    
    func intentToChange(nbrJours: Int) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nbrJoursChanging(nbrJours)) // emits an object of type IntentState
    }
    
    func intentToChange(idBenevoles: [String]) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.idBenevolesChanging(idBenevoles)) // emits an object of type IntentState
    }
    
    func intentToChange(isClosed: Bool) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.isClosedChanging(isClosed)) // emits an object of type IntentState
    }
    
    func intentToCreate(festival: Festival) async {
        if isFestivalValid(festival: festival) {
            switch await FestivalDAO.shared.createFestival(festival: festival) {
            case .failure(let error):
                self.formState.send(.error("\(error.localizedDescription)"))
                break
            case .success(let festival):
                // si ça a marché : modifier le view model et le model
                self.formState.send(.festivalUpdatedInDatabase)
                self.listState.send(.addingFestival(festival))
            }
        }
    }
    
    func intentToDelete(festivalId id: String, festivalIndex: Int) async {
        switch await FestivalDAO.shared.deleteFestivalById(id) {
        case .failure(let error):
            self.listState.send(.error("Error while deleting festival \(id): \(error.localizedDescription)"))
        case .success:
            self.listState.send(.deletingFestival(festivalIndex))
        }
    }
    
    private func isFestivalValid(festival: Festival) -> Bool {
        if festival.nom == "" {
            self.formState.send(.error("Name cannot be empty"))
            return false
        } else if festival.annee < Date.now {
            self.formState.send(.error("Date cannot be passed"))
            return false
        } else if festival.nbrJours < 1  {
            self.formState.send(.error("NbrJours cannot be 0"))
            return false
        } else {
            return true
        }
    }
    
}
