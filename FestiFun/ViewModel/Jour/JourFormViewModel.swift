//
//  JourFormViewModel.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import Foundation
import Combine


class JourFormViewModel : ObservableObject, Subscriber, JourObserver {
    
    private var model: Jour
    // save model in case the modification is cancelled
    private (set) var modelCopy: Jour
    
    var id: String?
    @Published var nom: String
    @Published var date: String
    @Published var debutHeure: String
    @Published var finHeure: String
    @Published var idFestival: String
    @Published var loading: Bool = false
    @Published var error: String?
    
    init(model: Jour) {
        self.id = model.id
        self.nom = model.nom
        self.date = model.date
        self.debutHeure = model.debutHeure
        self.finHeure = model.finHeure
        self.idFestival = model.idFestival
        self.model = model
        self.modelCopy = Jour(id: model.id, nom: model.nom, date: model.date, debutHeure: model.debutHeure,finHeure: model.finHeure, idFestival: model.idFestival)
        self.model.observer = self
    }
    
    
    func changed(nom: String) {
        self.nom = nom
    }
    
    func changed(date: String) {
        self.date = date
    }
    
    func changed(debutHeure: String) {
        self.debutHeure = debutHeure
    }
    
    func changed(finHeure: String) {
        self.finHeure = finHeure
    }
    
    func changed(idFestival: String) {
        self.idFestival = idFestival
    }
    
    
    typealias Input = JourFormIntentState
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
    func receive(_ input: JourFormIntentState) -> Subscribers.Demand {
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
                self.error = "The name can't be empty!"
            }
        case .dateChanging(let date):
            self.loading = false
            self.modelCopy.date = date
        case .debutHeureChanging(let debutHeure):
            self.loading = false
            self.modelCopy.debutHeure = debutHeure
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if modelCopy.debutHeure < dateFormatter.string(from: Date.now) { // there was an error
                self.error = "La date ne peut être passéé"
            }
        case .finHeureChanging(let finHeure):
            self.loading = false
            self.modelCopy.finHeure = finHeure
            if modelCopy.finHeure < modelCopy.debutHeure { // there was an error
                self.error = "L'heure de fin ne peut pas être avant l'heure de début"
            }
        case .idFestivalChanging(let idFestival):
            self.loading = false
            self.modelCopy.idFestival = idFestival
        case .jourUpdatedInDatabase(let jour):
            self.loading = false
            self.error = nil
            self.model.nom = jour.nom
            self.model.date = jour.date
            self.model.debutHeure = jour.debutHeure
            self.model.finHeure = jour.finHeure
            self.model.idFestival = jour.idFestival
        case .error(let errorMessage):
            self.loading = false
            self.error = errorMessage
        }
        
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
