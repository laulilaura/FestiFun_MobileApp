//
//  FestivalFormView.swift
//  FestiFun
//
//  Created by etud on 30/03/2023.
//

import SwiftUI
import Foundation


struct FestivalFormAdminView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    @Environment(\.presentationMode) var presentation
    
    @State private var newFestival: Festival = Festival(nom: "", annee: "2023", nbrJours: 1, idBenevoles: [], isClosed: false)
    
    var intent : FestivalIntent = FestivalIntent()
    
    @State var tabJours : [Jour] = []

    
    @State private var festivalFormFailedMessage : String?
    @State private var selected: [Bool] = [false, false, false]
    
    @State private var selectedYear = 2023
    let years = Array(2023...2030)
    
    var nbJourOk : Bool = true

        
    var body: some View {
        ScrollView {
            
            Text("Création d'un festival")
                .font(.title)
                .fontWeight(.bold)
            Text("Formulaire de création de festival sur l'App FestiFun,")
                .font(.footnote)
            Text("tous les champs doivent être rempli")
                .font(.footnote)
            Spacer()
            
            VStack {
                HStack {
                    Text("Nom")
                    TextField("nom", text: $newFestival.nom)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[0] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false, false]
                            selected[0] = true
                        }
                }
                .padding([.horizontal], 20)
                
                HStack {
                    Text("Année")
                    Picker("Année", selection: $selectedYear) {
                                ForEach(years, id: \.self) { year in
                                    Text(verbatim: "\(year)")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                }
                .padding([.horizontal], 20)
                
                HStack {
                    Text("Nombre de jour")
                    TextField("nbrJours", value: $newFestival.nbrJours, format: .number)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[2] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false, false]
                            selected[1] = true
                        }
                }
                .padding([.horizontal], 20)
                
                VStack(spacing: 20) {
                    if $newFestival.nbrJours.wrappedValue <= 0 {
                        Text("Nombre de jour minimum : 0")
                            .foregroundColor(.red)
                            .font(.footnote)
                            .italic()
                    } else if $newFestival.nbrJours.wrappedValue > 20 {
                        Text("Nombre de jour maximum : 20")
                            .foregroundColor(.red)
                            .font(.footnote)
                            .italic()
                    } else {
                        /*
                        VStack {
                            createJours()
                            ForEach(1...$newFestival.nbrJours.wrappedValue, id: \.self) { index in
                                VStack {
                                    Text("\(index)")
                                }
                                .padding()
                                .border(Color.gray, width: 1)
                            }
                        }
                         */
                    }
                }


                Text(self.festivalFormFailedMessage ?? "")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .italic()
            }
            
            Spacer()
            HStack {
                Spacer()
                Button("Créer ce festival") {
                    
                    newFestival.annee = "\(selectedYear)"
                    
                    var festivalVM : FestivalViewModel = FestivalViewModel(model: newFestival)
                    intent.addObserver(festivalFormViewModel: festivalVM)
                    
                    Task {
                        await intent.intentToCreate(festival: newFestival)
                        if festivalVM.error != nil {
                            festivalFormFailedMessage = festivalVM.error
                        }
                        else {
                            presentation.wrappedValue.dismiss()
                        }
                    }
                     
                }
                .padding(10)
                .background(Color.salmon)
                .foregroundColor(.white)
                .cornerRadius(8)
                Text(festivalFormFailedMessage ?? "")
                    .foregroundColor(.red)
             
            }
            
        }
        .listStyle(.plain)
        .padding()
    }
    
    func createJours() {
        tabJours.removeAll()
        for i in 0..<$newFestival.nbrJours.wrappedValue {
            tabJours.append(Jour(nom: "", date: "", debutHeure: "", finHeure: "", idFestival: ""))
        }
    }
}
/*
struct FestivalFormView_Previews: PreviewProvider {
    static var previews: some View {
        FestivalFormAdminView()
    }
}
*/
