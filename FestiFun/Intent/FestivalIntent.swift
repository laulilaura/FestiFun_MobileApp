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
    case loading
    case nomChanging(String)
    case anneeChanging(String)
    case nbrJoursChanging(Int)
    case idBenevolesChanging([String])
    case isClosedChanging(Bool)
    case festivalUpdatedInDatabase(Festival)
    case error(String)
}

enum FestivalListIntentState {
    case loading
    case uptodate
    case addingFestival(Festival)
    case deletingFestival(Int)
    case gettingFestival([Festival])
    case festivalUpdatedInDatabase(Festival)
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
    
    func intentToChange(nom: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nomChanging(nom)) // emits an object of type IntentState
    }
    
    func intentToChange(annee: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.anneeChanging(annee)) // emits an object of type IntentState
    }
    
    func intentToChange(nbrJours: Int) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nbrJoursChanging(nbrJours)) // emits an object of type IntentState
    }
    
    func intentToChange(idBenevoles: [String]) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.idBenevolesChanging(idBenevoles)) // emits an object of type IntentState
    }
    
    func intentToChange(isClosed: Bool) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.isClosedChanging(isClosed)) // emits an object of type IntentState
    }
    
    func intentToChange(festivalVM: FestivalViewModel) async {
        self.formState.send(.loading)
        let festival: Festival = Festival(nom: festivalVM.nom, annee: festivalVM.annee, nbrJours: festivalVM.nbrJours, idBenevoles: festivalVM.idBenevoles, isClosed: festivalVM.isClosed)
        if isFestivalValid(festival: festival) {
            switch await FestivalDAO.shared.updateFestival(festivalVM: festivalVM) {
            case .failure(let error):
                self.formState.send(.error("\(error.localizedDescription)"))
                break
            case .success(let festival):
                // si ça a marché : modifier le view model et le model
                self.formState.send(.festivalUpdatedInDatabase(festival))
                self.listState.send(.festivalUpdatedInDatabase(festival))
            }
        }
    }
    
    func intentToCreate(festival: Festival) async {
        self.listState.send(.loading)
        self.formState.send(.loading)
        if isFestivalValid(festival: festival) {
            switch await FestivalDAO.shared.createFestival(festival: festival) {
            case .failure(let error):
                self.formState.send(.error("\(error.localizedDescription)"))
                break
            case .success(let festival):
                // si ça a marché : modifier le view model et le model
                self.formState.send(.festivalUpdatedInDatabase(festival))
                self.listState.send(.addingFestival(festival))
            }
        }
    }
    
    func intentToDelete(festivalId id: String, festivalIndex: Int) async {
        self.listState.send(.loading)
        self.formState.send(.loading)
        switch await FestivalDAO.shared.deleteFestivalById(id) {
        case .failure(let error):
            self.listState.send(.error("Error while deleting festival \(id): \(error.localizedDescription)"))
        case .success:
            self.listState.send(.deletingFestival(festivalIndex))
        }
    }
    
    func intentToGetAll() async {
        self.listState.send(.loading)
        self.formState.send(.loading)
        switch await FestivalDAO.shared.getAllFestival() {
        case .failure(let error):
            self.formState.send(.error("Erreur : \(error.localizedDescription)"))
        case .success(let festivals):
            self.listState.send(.gettingFestival(festivals))
        }
    }
    
    func intentToGetAllByBenevole(benevoleId id: String) async {
        self.listState.send(.loading)
        self.formState.send(.loading)
        switch await FestivalDAO.shared.getFestivalsByBenevole(id: id) {
        case .failure(let error):
            self.formState.send(.error("Erreur : \(error.localizedDescription)"))
        case .success(let festivals):
            self.listState.send(.gettingFestival(festivals))
        }
    }
    
    func getFestivalsNewByBenevole(benevoleId id: String) async {
        self.listState.send(.loading)
        self.formState.send(.loading)
        switch await FestivalDAO.shared.getFestivalsNewByBenevole(id: id) {
        case .failure(let error):
            self.formState.send(.error("Erreur : \(error.localizedDescription)"))
        case .success(let festivals):
            self.listState.send(.gettingFestival(festivals))
        }
    }
    
    private func isFestivalValid(festival: Festival) -> Bool {
        if festival.nom == "" {
            self.formState.send(.error("Le nom ne peux être vide"))
            return false
        } /*else if DateFormatter.formatDate1.string(from: festival.annee) <= DateFormatter.formatDate1.string(from: Date.now) {
            self.formState.send(.error("La date ne peut être passée ou dans plus de 2 ans"))
            return false
        }*/ else if festival.nbrJours < 1  && festival.nbrJours > 31 {
            self.formState.send(.error("Il faut au moins 1 jour et moins de 31"))
            return false
        } else {
            return true
        }
    }
    
}
