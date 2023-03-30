//
//  ZoneFormViewModel.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation
import Combine


class ZoneFormViewModel : ObservableObject, Subscriber, ZoneObserver {
    
    private var model: Zone
    // save model in case the modification is cancelled
    private (set) var modelCopy: Zone
    
    var id: String?
    @Published var nom: String
    @Published var nbBenevolesNecessaires: Int
    @Published var nbBenevolesActuels: Int
    @Published var idFestival: String
    @Published var loading: Bool = false
    @Published var error: String?
    
    init(model: Zone) {
        self.id = model.id
        self.nom = model.nom
        self.nbBenevolesNecessaires = model.nbBenevolesNecessaires
        self.nbBenevolesActuels = model.nbBenevolesActuels
        self.idFestival = model.idFestival
        self.model = model
        self.modelCopy = Zone(id: model.id, nom: model.nom, nbBenevolesNecessaires: model.nbBenevolesNecessaires, nbBenevolesActuels: model.nbBenevolesActuels, idFestival: model.idFestival)
        self.model.observer = self
    }
    
    
    func changed(nom: String) {
        self.nom = nom
    }
    
    func changed(nbBenevolesNecessaires: Int) {
        self.nbBenevolesNecessaires = nbBenevolesNecessaires
    }
    
    func changed(nbBenevolesActuels: Int) {
        self.nbBenevolesActuels = nbBenevolesActuels
    }
    
    func changed(idFestival: String) {
        self.idFestival = idFestival
    }
    
    
    typealias Input = ZoneFormIntentState
    typealias Failure = Never
    
    // Called by Subscriber protocol during subscription
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    // Called if the publisher says it finished emitting (doesn't concern us)
    func receive(completion: Subscribers.Completion<Failure>) {
        return
    }
    
    // Called each time the publisher calls the "send" method to notify about state modification
    func receive(_ input: ZoneFormIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            self.loading = false
            break
        case .loading:
            self.loading = true
        case .nomChanging(let nom):
            self.loading = false
            let nameClean = nom.trimmingCharacters(in: .whitespacesAndNewlines)
            self.modelCopy.nom = nameClean
            if modelCopy.nom != nameClean { // there was an error
                self.error = "The name can't be empty!"
            }
        case .nbBenevolesNecessairesChanging(let nbBenevolesNecessaires):
            self.loading = false
            self.modelCopy.nbBenevolesNecessaires = nbBenevolesNecessaires
        case .nbBenevolesActuelsChanging(let nbBenevolesActuels):
            self.loading = false
            self.modelCopy.nbBenevolesActuels = nbBenevolesActuels
        case .idFestivalChanging(let idFestival):
            self.loading = false
            self.modelCopy.idFestival = idFestival
        case .zoneUpdatedInDatabase:
            self.loading = false
            self.error = nil
            self.model.nom = self.modelCopy.nom
            self.model.nbBenevolesNecessaires = self.modelCopy.nbBenevolesNecessaires
            self.model.nbBenevolesActuels = self.modelCopy.nbBenevolesActuels
            self.model.idFestival = self.modelCopy.idFestival
        case .error(let errorMessage):
            self.loading = false
            self.error = errorMessage
        }
        
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
