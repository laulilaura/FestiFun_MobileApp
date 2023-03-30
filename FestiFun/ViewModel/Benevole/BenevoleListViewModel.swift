//
//  BenevoleListViewModel.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import Foundation

import Combine

class BenevoleListViewModel: ObservableObject, Subscriber {
    
    @Published var benevoles : [LoggedBenevole]
    @Published var error: String?
    @Published var loading: Bool = false
    
    init(benevoles: [LoggedBenevole] = []) {
        self.benevoles = benevoles
    }
    
    typealias Input = BenevoleListIntentState
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
    func receive(_ input: BenevoleListIntentState) -> Subscribers.Demand {
        switch input {
        case .uptodate:
            self.loading = false
            break
        case .loading:
            self.loading = true
        case .addingBenevole(let benevole):
            self.loading = false
            self.benevoles.append(benevole)
        case .deletingBenevole(let benevoleIndex):
            self.loading = false
            let benevole = self.benevoles.remove(at: benevoleIndex)
            print("Deleting \(benevole.nom) of index \(benevoleIndex)")
        case .gettingBenevole(let benevoles):
            self.loading = false
            self.benevoles = benevoles
        case .error(let errorMessage):
            self.loading = false
            self.error = errorMessage
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
