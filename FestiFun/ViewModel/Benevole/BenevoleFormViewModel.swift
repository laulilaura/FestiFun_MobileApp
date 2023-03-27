//
//  BenevoleViewModel.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation
import Combine


class BenevoleFormViewModel : ObservableObject, Subscriber, BenevoleObserver {
    
    private var model: Benevole
    // save model in case the modification is cancelled
    private (set) var modelCopy: Benevole
    
    var id: String?
    @Published var nom: String
    @Published var prenom: String
    @Published var email: String
    @Published var password: String
    @Published var isAdmin: Bool
    @Published var error: String?
    
    init(model: Benevole) {
        self.id = model.id
        self.nom = model.nom
        self.prenom = model.prenom
        self.email = model.email
        self.password = model.password
        self.isAdmin = model.isAdmin
        self.model = model
        self.modelCopy = Benevole(id: model.id, nom: model.nom, prenom: model.prenom, email: model.email, password: model.password, isAdmin: model.isAdmin)
        self.model.observer = self
    }
    
    
    func changed(nom: String) {
        self.nom = nom
    }
    
    func changed(prenom: String) {
        self.prenom = prenom
    }
    
    func changed(email: String) {
        self.email = email
    }
    
    func changed(password: String) {
        self.password = password
    }
    
    func changed(isAdmin: Bool) {
        self.isAdmin = isAdmin
    }
    
    
    typealias Input = BenevoleFormIntentState
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
    func receive(_ input: BenevoleFormIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .nomChanging(let nom):
            let nameClean = nom.trimmingCharacters(in: .whitespacesAndNewlines)
            self.modelCopy.nom = nameClean
            if modelCopy.nom != nameClean { // there was an error
                self.error = "The name can't be empty!"
            }
        case .prenomChanging(let prenom):
            let nameClean = prenom.trimmingCharacters(in: .whitespacesAndNewlines)
            self.modelCopy.prenom = nameClean
            if modelCopy.prenom != nameClean { // there was an error
                self.error = "The name can't be empty!"
            }
        case .emailChanging(let email):
            let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            self.modelCopy.email = email
        case .passwordChanging(let password):
            self.modelCopy.password = password
        case .isAdminChanging(let isAdmin):
            self.modelCopy.isAdmin = isAdmin
        case .benevoleUpdatedInDatabase:
            self.error = nil
            self.model.nom = self.modelCopy.nom
            self.model.prenom = self.modelCopy.prenom
            self.model.email = self.modelCopy.email
            self.model.password = self.modelCopy.password
            self.model.isAdmin = self.modelCopy.isAdmin
        case .error(let errorMessage):
            self.error = errorMessage
        }
        
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
