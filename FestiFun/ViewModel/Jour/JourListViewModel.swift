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
            break
        case .addingJour(let jour):
            self.jours.append(jour)
        case .deletingJour(let joursIndex):
            let jour = self.jours.remove(at: joursIndex)
            print("Deleting \(jour.nom) of index \(joursIndex)")
        case .error(let errorMessage):
            self.error = errorMessage
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
