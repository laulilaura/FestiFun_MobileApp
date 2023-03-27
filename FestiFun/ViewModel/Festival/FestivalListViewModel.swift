//
//  FestivalListViewModel.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import Foundation
import Combine

class FestivalListViewModel: ObservableObject, Subscriber {
    
    @Published var festivals : [Festival]
    @Published var error: String?
    
    init(festivals: [Festival] = []) {
        self.festivals = festivals
    }
    
    typealias Input = FestivalListIntentState
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
    func receive(_ input: FestivalListIntentState) -> Subscribers.Demand {
        switch input {
        case .uptodate:
            break
        case .addingFestival(let festival):
            self.festivals.append(festival)
        case .deletingFestival(let festivalIndex):
            let festival = self.festivals.remove(at: festivalIndex)
            print("Deleting \(festival.nom) of index \(festivalIndex)")
        case .error(let errorMessage):
            self.error = errorMessage
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
