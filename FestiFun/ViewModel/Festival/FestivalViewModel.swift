//
//  FestivalViewModel.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import Foundation
import Combine


class FestivalViewModel : ObservableObject, Subscriber, FestivalObserver {
    private var model: Festival
    // save model in case the modification is cancelled
    private (set) var modelCopy: Festival
    
    var id: String?
    @Published var nom: String
    @Published var annee: Date
    @Published var nbrJours: Int
    @Published var idBenevoles: [String]
    @Published var isClosed: Bool
    @Published var loading: Bool = false
    @Published var error: String?
    
    init(model: Festival) {
        self.id = model.id
        self.nom = model.nom
        self.annee = model.annee
        self.nbrJours = model.nbrJours
        self.idBenevoles = model.idBenevoles
        self.isClosed = model.isClosed
        self.model = model
        self.modelCopy = Festival(id: model.id, nom: model.nom, annee: model.annee, nbrJours: model.nbrJours, idBenevoles: model.idBenevoles, isClosed: model.isClosed)
        self.model.observer = self
    }
    
    
    func changed(nom: String) {
        self.nom = nom
    }
    
    func changed(annee: Date) {
        self.annee = annee
    }
    
    func changed(nbrJours: Int) {
        self.nbrJours = nbrJours
    }
    
    func changed(idBenevoles: [String]) {
        self.idBenevoles = idBenevoles
    }
    
    func changed(isClosed: Bool) {
        self.isClosed = isClosed
    }
    
    
    typealias Input = FestivalIntentState
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
    func receive(_ input: FestivalIntentState) -> Subscribers.Demand {
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
                self.error = "Le nom ne peut être vide"
            }
        case .anneeChanging(let annee):
            self.loading = false
            self.modelCopy.annee = annee
            if modelCopy.annee < Date.now { // there was an error
                self.error = "La date ne peut être passéé"
            }
        case .nbrJoursChanging(let nbrJours):
            self.loading = false
            self.modelCopy.nbrJours = nbrJours
            if modelCopy.nbrJours < 1 { // there was an error
                self.error = "Le festival doit se dérouler sur au moins un jour"
            }
        case .idBenevolesChanging(let idBenevoles):
            self.loading = false
            self.modelCopy.idBenevoles = idBenevoles
        case .isClosedChanging(let isClosed):
            self.loading = false
            self.modelCopy.isClosed = isClosed
        case .festivalUpdatedInDatabase:
            self.loading = false
            self.error = nil
            self.model.nom = self.modelCopy.nom
            self.model.annee = self.modelCopy.annee
            self.model.nbrJours = self.modelCopy.nbrJours
            self.model.idBenevoles = self.modelCopy.idBenevoles
            self.model.isClosed = self.modelCopy.isClosed
        case .error(let errorMessage):
            self.loading = false
            self.error = errorMessage
        }
        
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
