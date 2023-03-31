//
//  CreneauFormViewModel.swift
//  FestiFun
//
//  Created by etud on 30/03/2023.
//

import Foundation
import Combine


class CreneauFormViewModel : ObservableObject, Subscriber, CreneauObserver {
    private var model: Creneau
    // save model in case the modification is cancelled
    private (set) var modelCopy: Creneau
    
    var id: String?
    @Published var heureDebut: Date
    @Published var heureFin: Date
    @Published var idJour: String
    @Published var loading: Bool = false
    @Published var error: String?
    
    init(model: Creneau) {
        self.id = model.id
        self.heureDebut = model.heureDebut
        self.heureFin = model.heureFin
        self.idJour = model.idJour
        self.model = model
        self.modelCopy = Creneau(heureDebut: model.heureDebut, heureFin: model.heureFin, idJour: model.idJour)
        self.model.observer = self
    }
    
    
    func changed(heureDebut: Date) {
        self.heureDebut = heureDebut
    }
    
    func changed(heureFin: Date) {
        self.heureFin = heureFin
    }
    
    func changed(idJour: String) {
        self.idJour = idJour
    }
    
    typealias Input = CreneauFormIntentState
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
    func receive(_ input: CreneauFormIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            self.loading = false
            break
        case .loading:
            self.loading = true
        case .heureDebutChanging(let heureDebut):
            self.loading = false
            self.modelCopy.heureDebut = heureDebut
        case .heureFinChanging(let heureFin):
            self.loading = false
            self.modelCopy.heureFin = heureFin
        case .idJourChanging(let idJour):
            self.loading = false
            self.modelCopy.idJour = idJour
        case .creneauUpdatedInDatabase(let creneau):
            self.loading = false
            self.error = nil
            self.model.heureDebut = creneau.heureDebut
            self.model.heureFin = creneau.heureFin
            self.model.idJour = creneau.idJour
        case .error(let errorMessage):
            self.loading = false
            self.error = errorMessage
        }
        
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
