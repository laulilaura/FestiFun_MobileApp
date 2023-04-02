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
    var intentJour : JourIntent = JourIntent()
    var intentZone : ZoneIntent = ZoneIntent()
    var intentCreneau : CreneauIntent = CreneauIntent()
    
    @State var tabJours : [Jour] = Array(repeating: Jour(nom: "", date: "", debutHeure: "", finHeure: "", idFestival: ""), count: 1)

    
    @State private var festivalFormFailedMessage : String?
    @State private var selected: [Bool] = [false, false, false]
    
    @State private var selectedYear = 2023
    let years = Array(2023...2030)
    
    private let hourFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()
    
    var nbJourOk : Bool = true
    
    @State var listAffiche : Bool = false
    
    @State var jourNotEmpty : Bool = false
        
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
                            listAffiche = false
                        }
                }
                .padding([.horizontal], 20)
                
                Button("Créer le tableau de jours") {
                    tabJours = Array(repeating: Jour(nom: "", date: "", debutHeure: "", finHeure: "", idFestival: ""), count: newFestival.nbrJours)
                    listAffiche = true
                            }
                
                VStack(spacing: 20) {
                    if(listAffiche) {
                        if newFestival.nbrJours <= 0 {
                            Text("Nombre de jour minimum : 1")
                                .foregroundColor(.red)
                                .font(.footnote)
                                .italic()
                        } else if newFestival.nbrJours > 20 {
                            Text("Nombre de jour maximum : 20")
                                .foregroundColor(.red)
                                .font(.footnote)
                                .italic()
                        } else {
                            
                            VStack {
                                ForEach(1...newFestival.nbrJours, id: \.self) { index in
                                    VStack {
                                        TextField("Nom", text: $tabJours[index-1].nom)
                                        TextField("Date : (format 01/01)", text: $tabJours[index-1].date)
                                        TextField("Heure de début : (format 00:00)", text: $tabJours[index-1].debutHeure)
                                        TextField("Heure de fin : (format 00:00)", text: $tabJours[index-1].finHeure)
                                    }
                                    .onTapGesture {
                                        jourNotEmpty = false
                                    }
                                    .padding()
                                    .border(Color.gray, width: 1)
                                }
                            }.onAppear(){
                                Task {
                                    debugPrint("dans le task")
                                    //createJours()
                                    self.tabJours = Array(repeating: Jour(nom: "", date: "", debutHeure: "", finHeure: "", idFestival: ""), count: newFestival.nbrJours)
                                }
                                
                            }
                        }
                    }
                    
                }
            }
            Text(self.festivalFormFailedMessage ?? "")
                .foregroundColor(.red)
                .font(.footnote)
                .italic()
            Spacer()
            HStack {
                Spacer()
                Button("Créer ce festival") {
                    Task {
                        for j in 0...tabJours.count-1 {
                            debugPrint(j)
                            if (tabJours[j].date.isEmpty || tabJours[j].nom.isEmpty || tabJours[j].finHeure.isEmpty || tabJours[j].debutHeure.isEmpty) {
                                jourNotEmpty = true
                                break
                            }
                        }
                        if (newFestival.nom.isEmpty) {
                            festivalFormFailedMessage = "Le nom ne peut être vide"
                        } else if (jourNotEmpty){
                            festivalFormFailedMessage = "Les jours doivent être correctement completés."
                        } else {
                            newFestival.annee = "\(selectedYear)"
                            switch await FestivalDAO.shared.createFestival(festival: newFestival) {
                            case .failure(let error):
                                festivalFormFailedMessage = "\(error)"
                            case .success(let fest):
                                var idFest = fest.id
                                for k in 0...newFestival.nbrJours-1 {
                                    let jo : Jour = tabJours[k]
                                    jo.idFestival = idFest!
                                    //var jourVM : JourFormViewModel = JourFormViewModel(model: jo)
                                    //intentJour.addObserver(jourFormViewModel: jourVM)
                                    //await intentJour.intentToCreate(jour: jo)
                                    switch await JourDAO.shared.createJour(jour: jo) {
                                    case .failure(let error):
                                        festivalFormFailedMessage = "\(error)"
                                    case .success(let jour):
                                        await intentCreneau.intentToCreate(creneau: Creneau(id: jour.id, heureDebut: jo.debutHeure, heureFin: jo.finHeure, idJour: jour.id!))
                                    }
                                }
                                var zone : Zone = Zone(nom: "libre", nbBenevolesNecessaires: 0, nbBenevolesActuels: 0, idFestival: idFest!)
                                await intentZone.intentToCreate(Zone: zone)
                                presentation.wrappedValue.dismiss()
                            }
                        }
                    }
                }
                .disabled(!listAffiche)
                .padding(10)
                .background(listAffiche ? Color.salmon : Color.lightgrey)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                
                
             
            }
            
        }
        .listStyle(.plain)
        .padding()
    }
    
    /*
    func createJours() {
        tabJours.removeAll()
        for i in 0..<$newFestival.nbrJours.wrappedValue {
            tabJours.append(Jour(nom: "", date: "", debutHeure: "", finHeure: "", idFestival: ""))
        }
    }
     */
}
/*
struct FestivalFormView_Previews: PreviewProvider {
    static var previews: some View {
        FestivalFormAdminView()
    }
}
*/
