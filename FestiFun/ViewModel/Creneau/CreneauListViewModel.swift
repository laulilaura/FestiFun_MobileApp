//
//  CreneauListViewModel.swift
//  FestiFun
//
//  Created by etud on 30/03/2023.
//

import Foundation
import Combine

class CreneauListViewModel: ObservableObject, Subscriber {
    
    @Published var creneaux : [Creneau]
    @Published var error: String?
    @Published var loading: Bool = false
    
    init() {
        self.creneaux = []
    }
    
    typealias Input = CreneauListIntentState
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
    func receive(_ input: CreneauListIntentState) -> Subscribers.Demand {
        switch input {
        case .uptodate:
            self.loading = false
            break
        case .loading:
            self.loading = true
        case .addingCreneau(let creneau):
            self.loading = false
            self.creneaux.append(creneau)
        case .deletingCreneau(let creneauIndex):
            self.loading = false
            let creneau = self.creneaux.remove(at: creneauIndex)
            print("Deleting \(creneau.heureDebut) : \(creneau.heureFin) of index \(creneauIndex)")
        case .gettingCreneau(let creneaux):
            self.loading = false
            self.creneaux = creneaux
        case .error(let errorMessage):
            self.loading = false
            self.error = errorMessage
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
