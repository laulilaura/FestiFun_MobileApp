//
//  ZoneIntent.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation
import Combine

enum ZoneIntentState {
    case ready
    case nomChanging(String)
    case nbBenevolesNecessairesChanging(Int)
    case nbBenevolesActuelsChanging(Int)
    case idFestivalChanging(String)
    case zoneUpdatedInDatabase
    case error(String)
}

enum ZoneListIntentState {
    case uptodate
    case addingZone(Zone)
    case deletingZone(Int)
    case error(String)
}

struct ZoneIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    private var formState = PassthroughSubject<ZoneIntentState, Never>()
    private var listState = PassthroughSubject<ZoneListIntentState, Never>()
    
    func addObserver(zoneFormViewModel: ZoneViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.formState.subscribe(zoneFormViewModel)
    }
    
    func addObserver(zoneListViewModel: ZoneListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(zoneListViewModel)
    }
    
    // MARK: intentToChange functions
    
    func intentToChange(nom: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nomChanging(nom)) // emits an object of type IntentState
    }
    
    func intentToChange(nbBenevolesNecessaires: Int) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nbBenevolesNecessairesChanging(nbBenevolesNecessaires)) // emits an object of type IntentState
    }

    func intentToChange(nbBenevolesActuels: Int) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nbBenevolesActuelsChanging(nbBenevolesActuels)) // emits an object of type IntentState
    }

    func intentToChange(idFestival: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.idFestivalChanging(idFestival)) // emits an object of type IntentState
    }
    
    func intentToCreate(Zone: Zone) async {
            switch await ZoneDAO.shared.createZone(Zone: Zone) {
            case .failure(let error):
                self.formState.send(.error("\(error.localizedDescription)"))
                break
            case .success(let Zone):
                // si ça a marché : modifier le view model et le model
                self.formState.send(.zoneUpdatedInDatabase)
                self.listState.send(.addingZone(Zone))
            }
    }
    
    func intentToDelete(zoneId id: String, zoneIndex: Int) async {
        switch await ZoneDAO.shared.deleteZoneById(id) {
        case .failure(let error):
            self.listState.send(.error("Error while deleting zone \(id): \(error.localizedDescription)"))
        case .success:
            self.listState.send(.deletingZone(zoneIndex))
        }
    }
    
}
