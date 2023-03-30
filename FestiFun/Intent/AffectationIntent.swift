//
//  AffectationIntent.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation
import Combine

enum AffectationFormIntentState {
    case ready
    case loading
    case idBenevolesChanging([String])
    case idCreneauChanging(String)
    case idZoneChanging(String)
    case idFestivalChanging(String)
    case affectationUpdatedInDatabase
    case error(String)
}

enum AffectationListIntentState {
    case uptodate
    case loading
    case addingAffectation(Affectation)
    case deletingAffectation(Int)
    case gettingAffectation([Affectation])
    case error(String)
}

struct AffectationIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    private var formState = PassthroughSubject<AffectationFormIntentState, Never>()
    private var listState = PassthroughSubject<AffectationListIntentState, Never>()
    
    func addObserver(affectationFormViewModel: AffectationFormViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.formState.subscribe(affectationFormViewModel)
    }
    
    func addObserver(affectationListViewModel: AffectationListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(affectationListViewModel)
    }
    
    // MARK: intentToChange functions
    
    func intentToChange(idBenevoles: [String]) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.idBenevolesChanging(idBenevoles)) // emits an object of type IntentState
    }

    func intentToChange(idCreneau: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.idCreneauChanging(idCreneau)) // emits an object of type IntentState
    }

    func intentToChange(idZone: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.idZoneChanging(idZone)) // emits an object of type IntentState
    }

    func intentToChange(idFestival: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.idFestivalChanging(idFestival)) // emits an object of type IntentState
    }
    
    func intentToCreate(affectation: Affectation) async {
        self.formState.send(.loading)
        self.listState.send(.loading)
        switch await AffectationDAO.shared.createAffectation(affectation: affectation) {
            case .failure(let error):
                self.formState.send(.error("\(error.localizedDescription)"))
                break
            case .success(let affectation):
                // si ça a marché : modifier le view model et le model
                self.formState.send(.affectationUpdatedInDatabase)
                self.listState.send(.addingAffectation(affectation))
        }
    }
    
    func intentToDelete(affectationId id: String, affectationIndex: Int) async {
        self.formState.send(.loading)
        self.listState.send(.loading)
        switch await AffectationDAO.shared.deleteAffectationById(id) {
            case .failure(let error):
                self.listState.send(.error("Error while deleting affectation \(id): \(error.localizedDescription)"))
            case .success:
                self.listState.send(.deletingAffectation(affectationIndex))
        }
    }
    
    func intentToGetAll() async {
        self.listState.send(.loading)
        self.formState.send(.loading)
        switch await AffectationDAO.shared.getAllAffectation() {
        case .failure(let error):
            self.formState.send(.error("Erreur : \(error.localizedDescription)"))
        case .success(let affectations):
            self.listState.send(.gettingAffectation(affectations))
        }
    }
    
}

