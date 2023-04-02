//
//  UpdateZoneAdminView.swift
//  FestiFun
//
//  Created by etud on 31/03/2023.
//

import SwiftUI

struct UpdateZoneAdminView: View {
    
    @ObservedObject var zone : ZoneFormViewModel
    
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.fixed(80)),
        GridItem(.flexible()),
    ]
    
    var intent: ZoneIntent = ZoneIntent()
    
    @State var nom: String
    @State var nbBenevolesNecessaires: Int
    @State var nbBenevolesActuels: Int
    
    
    init(zone: ZoneFormViewModel) {
        self.zone = zone
        self._nom = State(initialValue: zone.nom)
        self._nbBenevolesNecessaires = State(initialValue: zone.nbBenevolesNecessaires)
        self._nbBenevolesActuels = State(initialValue: zone.nbBenevolesActuels)
    }
    
    var body: some View {
        
        VStack {
            Spacer().frame(height: 20)
            Text("Modification des informations de la zone")
                .font(.footnote)
            if zone.loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            else if zone.error != nil {
                Text("Il y a eu une erreur").italic()
            } else {
                Spacer()
                LazyVGrid(columns: columns, spacing: 20) {
                    Text("Nom : ").frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Esplanade", text: $nom)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    Text("Nombre de bénévoles actuels : ").frame(maxWidth: .infinity, alignment: .leading)
                    TextField("10", value: $nbBenevolesActuels, formatter: NumberFormatter())
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    Text("Nombre de bénévoles nécessaires : ").frame(maxWidth: .infinity, alignment: .leading)
                    TextField("10", value: $nbBenevolesNecessaires, formatter: NumberFormatter())
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 40)
                Spacer().frame(height: 50)
                Button("Modifier les informations de la zone") {
                    Task {
                        zone.nom = self.nom
                        zone.nbBenevolesNecessaires = self.nbBenevolesNecessaires
                        zone.nbBenevolesActuels = self.nbBenevolesActuels
                        debugPrint("ICIIIII")
                        await intent.intentToChange(zoneVM: zone)
                        debugPrint("LAAAAAA")
                        if zone.error == nil {
                            dismiss()
                        }
                    }
                }
                .padding(10)
                .background(Color.salmon)
                .foregroundColor(.white)
                .cornerRadius(8)
                Spacer()
            }
        }
    }
}
