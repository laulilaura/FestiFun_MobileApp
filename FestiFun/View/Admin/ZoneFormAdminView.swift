//
//  ZoneFormView.swift
//  FestiFun
//
//  Created by etud on 30/03/2023.
//

import SwiftUI
import Foundation


struct ZoneFormAdminView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    @Environment(\.presentationMode) var presentation
    
    
    @ObservedObject var festVM : FestivalViewModel
    
    @State private var newZone: Zone = Zone(nom: "", nbBenevolesNecessaires: 1, nbBenevolesActuels: 0 ,idFestival: "")
    
    var intent : ZoneIntent = ZoneIntent()    

    @State private var zoneFormFailedMessage : String?
    @State private var selected: [Bool] = [false, false]
    
            
    var body: some View {
        ScrollView {
            
            Text("Création d'une zone")
                .font(.title)
                .fontWeight(.bold)
            Text("Formulaire de création d'une zone pour le festival \(festVM.nom)")
                .font(.footnote)
            Text("tous les champs doivent être rempli")
                .font(.footnote)
            Image("zone")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.bottom,30)
            Spacer()
            
            VStack {
                HStack {
                    Text("Nom")
                    TextField("nom", text: $newZone.nom)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[0] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false]
                            selected[0] = true
                        }
                }
                .padding([.horizontal], 20)
                
                HStack {
                    Text("Nombre de bénévoles nécessaires")
                    TextField("nbBenevolesNecessaires", value: $newZone.nbBenevolesNecessaires, format: .number)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[1] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false]
                            selected[1] = true
                        }
                }
                .padding([.horizontal], 20)

                Text(self.zoneFormFailedMessage ?? "")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .italic()

                    
                Button("Créer") {
                    Task {
                        newZone.idFestival = festVM.id!
                        if newZone.nom.isEmpty {
                           self.zoneFormFailedMessage = "Le nom ne peut pas être vide"
                        } else if newZone.nbBenevolesNecessaires < 1 {
                            self.zoneFormFailedMessage = "Au moins un bénévole est nécéssaire"
                        } else {
                           switch await ZoneDAO.shared.createZone(zone: newZone) {
                           case .failure(let error):
                               self.zoneFormFailedMessage = error.localizedDescription
                               break
                           case .success(let zone):
                               await intent.intentToCreate(Zone: zone)
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
