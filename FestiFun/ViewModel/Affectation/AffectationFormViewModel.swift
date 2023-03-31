//
//  AffectationViewModel.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation
import Combine


class AffectationFormViewModel : ObservableObject, Subscriber, AffectationObserver {
    private var model: Affectation
    // save model in case the modification is cancelled
    private (set) var modelCopy: Affectation
    
    var id: String?
    @Published var idBenevoles: [String]
    @Published var idCreneau: String
    @Published var idZone: String
    @Published var idFestival: String
    @Published var loading: Bool = false
    @Published var error: String?
    
    init(model: Affectation) {
        self.id = model.id
        self.idBenevoles = model.idBenevoles
        self.idCreneau = model.idCreneau
        self.idZone = model.idZone
        self.idFestival = model.idFestival
        self.model = model
        self.modelCopy = Affectation(idBenevoles: model.idBenevoles, idCreneau: model.idCreneau, idZone: model.idZone, idFestival: model.idFestival)
        self.model.observer = self
    }
    
    func changed(idBenevoles: [String]) {
        self.idBenevoles = idBenevoles
    }
    
    func changed(idCreneau: String) {
        self.idCreneau = idCreneau
    }
    
    func changed(idZone: String) {
        self.idZone = idZone
    }
    
    func changed(idFestival: String) {
        self.idFestival = idFestival
    }
    
    
    typealias Input = AffectationFormIntentState
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
    func receive(_ input: AffectationFormIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            self.loading = false
            break
        case .loading:
            self.loading = true
        case .idBenevolesChanging(let idBenevoles) :
            self.loading = false
            self.modelCopy.idBenevoles = idBenevoles
        case .idCreneauChanging(let idCreneau):
            self.loading = false
            self.modelCopy.idCreneau = idCreneau
        case .idZoneChanging(let idZone):
            self.loading = false
            self.modelCopy.idZone = idZone
        case .idFestivalChanging(let idFestival):
            self.loading = false
            self.modelCopy.idFestival = idFestival
        case .affectationUpdatedInDatabase(let affectation):
            self.loading = false
            self.error = nil
            self.model.idBenevoles = affectation.idBenevoles
            self.model.idCreneau = affectation.idCreneau
            self.model.idZone = affectation.idZone
            self.model.idFestival = affectation.idFestival
        case .error(let errorMessage):
            self.loading = false
            self.error = errorMessage
        }
        
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
