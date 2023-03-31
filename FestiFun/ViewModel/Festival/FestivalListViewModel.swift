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
    @Published var loading: Bool = false
    
    init() {
        self.festivals = []
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
            self.loading = false
            break
        case .loading:
            self.loading = true
        case .addingFestival(let festival):
            self.loading = false
            self.festivals.append(festival)
        case .deletingFestival(let festivalIndex):
            self.loading = false
            let festival = self.festivals.remove(at: festivalIndex)
            print("Deleting \(festival.nom) of index \(festivalIndex)")
        case .gettingFestival(let festivals):
            self.loading = false
            self.festivals = festivals
        case .festivalUpdatedInDatabase(let festival):
            self.loading = false
            if let index = self.festivals.firstIndex(where: { $0.id == festival.id }) {
                self.festivals[index] = festival
                    }

        case .error(let errorMessage):
            self.loading = false
            self.error = errorMessage
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
