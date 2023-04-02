//
//  ZoneFormView.swift
//  FestiFun
//
//  Created by Laura on 30/03/2023.
//

import SwiftUI
import Foundation


struct JourFormAdminView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    @Environment(\.presentationMode) var presentation
    
    
    @ObservedObject var festVM : FestivalViewModel
    
    @State private var newJour: Jour = Jour(nom: "", date: "", debutHeure: "", finHeure: "", idFestival: "")
    
    var intent : JourIntent = JourIntent()
    var intentCreneau : CreneauIntent = CreneauIntent()

    @State private var jourFormFailedMessage : String?
    @State private var selected: [Bool] = [false, false, false, false]
    
            
    var body: some View {
        ScrollView {
            
            Text("Création d'un jour")
                .font(.title)
                .fontWeight(.bold)
            Text("Formulaire de création d'un jour pour le festival \(festVM.nom)")
                .font(.footnote)
            Text("tous les champs doivent être rempli")
                .font(.footnote)
            Image("jour")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.bottom,30)
            Spacer()
            
            VStack {
                HStack {
                    Text("Nom")
                    TextField("nom", text: $newJour.nom)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[0] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false, false, false]
                            selected[0] = true
                        }
                }
                .padding([.horizontal], 20)
                
                HStack {
                    Text("Date")
                    TextField("date de la journée", text: $newJour.date)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[1] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false, false, false]
                            selected[1] = true
                        }
                }
                .padding([.horizontal], 20)
                
                HStack {
                    Text("Début journée")
                    TextField("heure de début (format 00:00)", text: $newJour.debutHeure)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[2] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false, false, false]
                            selected[2] = true
                        }
                }
                .padding([.horizontal], 20)
                
                
                HStack {
                    Text("Fin de journée")
                    TextField("heure de fin (format 00:00)", text: $newJour.finHeure)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[3] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false, false, false]
                            selected[3] = true
                        }
                }
                .padding([.horizontal], 20)

                Text(self.jourFormFailedMessage ?? "")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .italic()

                    
                Button("Créer") {
                    Task {
                        newJour.idFestival = festVM.id!
                        if newJour.nom.isEmpty || newJour.date.isEmpty || newJour.debutHeure.isEmpty || newJour.finHeure.isEmpty {
                           self.jourFormFailedMessage = "Les informations ne peuvent pas être vide"
                        } else {
                           switch await JourDAO.shared.createJour(jour: newJour){
                           case .failure(let error):
                               self.jourFormFailedMessage = error.localizedDescription
                               break
                           case .success(let jour):
                               await intentCreneau.intentToCreate(creneau: Creneau(id: jour.id, heureDebut: jour.debutHeure, heureFin: jour.finHeure, idJour: jour.id!))
                               await intent.intentToCreate(jour: jour)
                               self.presentation.wrappedValue.dismiss()
                               break
                           }
                       }
                    }
                }
                .padding(10)
                .background(Color.salmon)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .listStyle(.plain)
        .padding()
    }
}
