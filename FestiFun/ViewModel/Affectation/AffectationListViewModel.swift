//
//  AffectationListViewModel.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation
import Combine

class AffectationListViewModel: ObservableObject, Subscriber {
    
    @Published var affectations : [Affectation]
    @Published var error: String?
    
    init(affectations: [Affectation] = []) {
        self.affectations = affectations
    }
    
    typealias Input = AffectationListIntentState
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
    func receive(_ input: AffectationListIntentState) -> Subscribers.Demand {
        switch input {
        case .uptodate:
            break
        case .addingAffectation(let affectation):
            self.affectations.append(affectation)
        case .deletingAffectation(let affectationIndex):
            let affectation = self.affectations.remove(at: affectationIndex)
            print("Deleting \(affectation.idBenevoles) of index \(affectationIndex)")
        case .error(let errorMessage):
            self.error = errorMessage
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
