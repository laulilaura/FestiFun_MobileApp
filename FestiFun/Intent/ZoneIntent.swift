//
//  ZoneIntent.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation
import Combine

enum ZoneFormIntentState {
    case ready
    case loading
    case nomChanging(String)
    case nbBenevolesNecessairesChanging(Int)
    case nbBenevolesActuelsChanging(Int)
    case idFestivalChanging(String)
    case zoneUpdatedInDatabase(Zone)
    case error(String)
}

enum ZoneListIntentState {
    case uptodate
    case loading
    case addingZone(Zone)
    case deletingZone(Int)
    case gettingZone([Zone])
    case zoneUpdatedInDatabase(Zone)
    case error(String)
}

struct ZoneIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    private var formState = PassthroughSubject<ZoneFormIntentState, Never>()
    private var listState = PassthroughSubject<ZoneListIntentState, Never>()
    
    func addObserver(zoneFormViewModel: ZoneFormViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.formState.subscribe(zoneFormViewModel)
    }
    
    func addObserver(zoneListViewModel: ZoneListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(zoneListViewModel)
    }
    
    // MARK: intentToChange functions
    
    func intentToChange(nom: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nomChanging(nom)) // emits an object of type IntentState
    }
    
    func intentToChange(nbBenevolesNecessaires: Int) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nbBenevolesNecessairesChanging(nbBenevolesNecessaires)) // emits an object of type IntentState
    }

    func intentToChange(nbBenevolesActuels: Int) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nbBenevolesActuelsChanging(nbBenevolesActuels)) // emits an object of type IntentState
    }

    func intentToChange(idFestival: String) async {
        self.formState.send(.loading)
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.idFestivalChanging(idFestival)) // emits an object of type IntentState
    }
    
    func intentToChange(zoneVM: ZoneFormViewModel) async {
        self.formState.send(.loading)
        switch await ZoneDAO.shared.updateZone(zoneVM: zoneVM) {
        case .failure(let error):
            self.formState.send(.error("\(error.localizedDescription)"))
            break
        case .success(let zone):
            // si ça a marché : modifier le view model et le model
            self.formState.send(.zoneUpdatedInDatabase(zone))
            self.listState.send(.zoneUpdatedInDatabase(zone))
        }
    }
    
    func intentToCreate(Zone: Zone) async {
        self.formState.send(.loading)
        self.listState.send(.loading)
            switch await ZoneDAO.shared.createZone(zone: Zone) {
            case .failure(let error):
                self.formState.send(.error("\(error.localizedDescription)"))
                break
            case .success(let zone):
                // si ça a marché : modifier le view model et le model
                self.formState.send(.zoneUpdatedInDatabase(zone))
                self.listState.send(.addingZone(zone))
            }
    }
    
    func intentToDelete(zoneId id: String, zoneIndex: Int) async {
        self.formState.send(.loading)
        self.listState.send(.loading)
        switch await ZoneDAO.shared.deleteZoneById(id) {
        case .failure(let error):
            self.listState.send(.error("Error while deleting zone \(id): \(error.localizedDescription)"))
        case .success:
            self.listState.send(.deletingZone(zoneIndex))
        }
    }
    
    func intentToGetAll(idFestival: String) async {
        self.listState.send(.loading)
        self.formState.send(.loading)
        switch await ZoneDAO.shared.getAllZone(idFestival: idFestival) {
        case .failure(let error):
            self.formState.send(.error("Erreur : \(error.localizedDescription)"))
        case .success(let zones):
            self.listState.send(.gettingZone(zones))
        }
    }
    
}

