//
//  UpdateFestivalAdminView.swift
//  FestiFun
//
//  Created by etud on 31/03/2023.
//

import SwiftUI

struct UpdateFestivalAdminView: View {
    
    @ObservedObject var fest : FestivalViewModel
    
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.fixed(80)),
        GridItem(.flexible()),
    ]
    
    var intent: FestivalIntent = FestivalIntent()
    
    @State var nom: String
    @State var annee: String
    @State var nbrJours: Int
    @State var isClosed: Bool
    
    
    init(fest: FestivalViewModel) {
        self.fest = fest
        self._nom = State(initialValue: fest.nom)
        self._annee = State(initialValue: fest.annee)
        self._nbrJours = State(initialValue: fest.nbrJours)
        self._isClosed = State(initialValue: !fest.isClosed)
    }
    
    var body: some View {
        
        VStack {
            Spacer().frame(height: 20)
            Text("Modification des informations du festival")
                .font(.footnote)
            if fest.loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            else if fest.error != nil {
                Text("Il y a eu une erreur").italic()
            } else {
                Spacer()
                LazyVGrid(columns: columns, spacing: 20) {
                    Text("Nom : ").frame(maxWidth: .infinity, alignment: .leading)
                    TextField("HellFest", text: $nom)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    Text("Année : ").frame(maxWidth: .infinity, alignment: .leading)
                    TextField("2022", text: $annee)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    Text("Ouvert : ").frame(maxWidth: .infinity, alignment: .leading)
                    Toggle("", isOn: $isClosed)
                }
                .padding(.horizontal, 40)
                Spacer().frame(height: 50)
                Button("Modifier les informations du festival") {
                    Task {
                        fest.nom = self.nom
                        fest.annee = self.annee
                        fest.nbrJours = self.nbrJours
                        fest.isClosed = !self.isClosed
                        debugPrint("ICIIIII")
                        await intent.intentToChange(festivalVM: fest)
                        debugPrint("LAAAAAA")
                        if fest.error == nil {
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
