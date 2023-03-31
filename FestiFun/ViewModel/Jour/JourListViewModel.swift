//
//  JourListViewModel.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation
import Combine

class JourListViewModel: ObservableObject, Subscriber {
    
    @Published var jours : [Jour]
    @Published var error: String?
    @Published var loading: Bool = false
    
    init(jours: [Jour] = []) {
        self.jours = jours
    }
    
    typealias Input = JourListIntentState
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
    func receive(_ input: JourListIntentState) -> Subscribers.Demand {
        switch input {
        case .uptodate:
            self.loading = false
            break
        case .loading:
            self.loading = true
        case .addingJour(let jour):
            self.loading = false
            self.jours.append(jour)
        case .deletingJour(let joursIndex):
            self.loading = false
            let jour = self.jours.remove(at: joursIndex)
            print("Deleting \(jour.nom) of index \(joursIndex)")
        case .gettingJour(let jours):
            self.loading = false
            self.jours = jours
        case .jourUpdatedInDatabase(let jour):
            self.loading = false
            if let index = self.jours.firstIndex(where: { $0.id == jour.id }) {
                self.jours[index] = jour
                    }
        case .error(let errorMessage):
            self.loading = false
            self.error = errorMessage
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
