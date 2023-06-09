//
//  CreneauIntent.swift
//  FestiFun
//
//  Created by Laura on 28/03/2023.
//

import Foundation
import Combine

enum CreneauFormIntentState {
    case ready
    case loading
    case heureDebutChanging(String)
    case heureFinChanging(String)
    case idJourChanging(String)
    case creneauUpdatedInDatabase(Creneau)
    case error(String)
}

enum CreneauListIntentState {
    case uptodate
    case loading
    case addingCreneau(Creneau)
    case deletingCreneau(Int)
    case gettingCreneau([Creneau])
    case creneauUpdatedInDatabase(Creneau)
    case error(String)
}

struct CreneauIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    private var formState = PassthroughSubject<CreneauFormIntentState, Never>()
    private var listState = PassthroughSubject<CreneauListIntentState, Never>()
    
    
    func addObserver(creneauFormViewModel: CreneauFormViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.formState.subscribe(creneauFormViewModel)
    }
    
    func addObserver(creneauListViewModel: CreneauListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(creneauListViewModel)
    }
    
    // MARK: intentToChange functions
    
    func intentToChange(heureDebut: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.heureDebutChanging(heureDebut)) // emits an object of type IntentState
    }

    func intentToChange(heureFin: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.heureFinChanging(heureFin)) // emits an object of type IntentState
    }

    func intentToChange(jour: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.idJourChanging(jour)) // emits an object of type IntentState
    }
    
    func intentToChange(creneauVM: CreneauFormViewModel) async {
        self.formState.send(.loading)
        switch await CreneauDAO.shared.updateCreneau(creneauVM: creneauVM) {
        case .failure(let error):
            self.formState.send(.error("\(error.localizedDescription)"))
            break
        case .success(let creneau):
            // si ça a marché : modifier le view model et le model
            self.formState.send(.creneauUpdatedInDatabase(creneau))
            self.listState.send(.creneauUpdatedInDatabase(creneau))
        }
    }
    
    func intentToCreate(creneau: Creneau) async {
            switch await CreneauDAO.shared.createCreneau(creneau: creneau) {
            case .failure(let error):
                self.formState.send(.error("\(error.localizedDescription)"))
                break
            case .success(let creneau):
                // si ça a marché : modifier le view model et le model
                self.formState.send(.creneauUpdatedInDatabase(creneau))
                self.listState.send(.addingCreneau(creneau))
            }
    }
    
    func intentToDelete(creneauId id: String, creneauIndex: Int) async {
        switch await CreneauDAO.shared.deleteCreneauById(id) {
        case .failure(let error):
            self.listState.send(.error("Error while deleting creneau \(id): \(error.localizedDescription)"))
        case .success:
            self.listState.send(.deletingCreneau(creneauIndex))
        }
    }
    
}
