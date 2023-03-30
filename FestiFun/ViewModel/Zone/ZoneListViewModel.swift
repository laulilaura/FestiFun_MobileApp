//
//  ZoneListViewModel.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation
import Combine

class ZoneListViewModel: ObservableObject, Subscriber {
    
    @Published var zones : [Zone]
    @Published var error: String?
    @Published var loading: Bool = false
    
    init(zones: [Zone] = []) {
        self.zones = zones
    }
    
    typealias Input = ZoneListIntentState
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
    func receive(_ input: ZoneListIntentState) -> Subscribers.Demand {
        switch input {
        case .uptodate:
            self.loading = false
            break
        case .loading:
            self.loading = true
        case .addingZone(let zone):
            self.loading = false
            self.zones.append(zone)
        case .deletingZone(let zoneIndex):
            self.loading = false
            let zone = self.zones.remove(at: zoneIndex)
            print("Deleting \(zone.nom) of index \(zoneIndex)")
        case .gettingZone(let zones):
            self.loading = false
            self.zones = zones
        case .error(let errorMessage):
            self.loading = false
            self.error = errorMessage
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
