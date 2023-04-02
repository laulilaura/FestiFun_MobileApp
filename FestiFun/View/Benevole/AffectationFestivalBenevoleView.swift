//
//  AffectationFestivalBenevoleView.swift
//  FestiFun
//
//  Created by Laura on 02/04/2023.
//

import SwiftUI

struct AffectationFestivalBenevoleView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    @ObservedObject var festVM : FestivalViewModel
    
    @State var intentFestival : FestivalIntent = FestivalIntent()
    
    @State var errorMessage : String = ""
    
    @Environment(\.dismiss) var dismiss
    
    let columns = [
            GridItem(.fixed(100)),
            GridItem(.flexible()),
        ]
    
    @State var count: Int = 0
    
    var body: some View {
        VStack {
            Text("Festival")
                .font(.title)
                .fontWeight(.bold)
            Text(festVM.nom)
                .font(.title)
            Image("rejoindre")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80, alignment: .center)
            Text("Informations sur le festival:")
                .font(.footnote)
            LazyVGrid(columns: columns, spacing: 10) {
                Text("Année : ").frame(maxWidth: .infinity, alignment: .leading)
                Text(festVM.annee).foregroundColor(Color.salmon).frame(maxWidth: .infinity, alignment: .leading)
                Text("Nombre de jours : ").frame(maxWidth: .infinity, alignment: .leading)
                Text("\(festVM.nbrJours)").foregroundColor(Color.salmon).frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 40)
            
            HStack {
                Text("Nombre d'affectation souhaité :").padding()
                Text("\(count)").padding()
                
                Button(action: {
                    self.count -= 1
                }) {
                    Image(systemName: "minus.circle")
                }
                .padding()
                            
                Button(action: {
                    self.count += 1
                }) {
                    Image(systemName: "plus.circle")
                }
                .padding()
            }
            
            ForEach(0..<count, id: \.self) { index in
                VStack {
                    Text("Stack \(index)")
                        .font(.title)
                        .padding()
                    Divider()
                }
            }
            
            // les VStack permmettent de séléctionner un jour et une zone (select parmis ceux existant) (si même jour devenir disable ?)
            // Activer l'affectation à la fin
        }
    }
}
