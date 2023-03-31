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
    
    @State private var newFestival: Festival = Festival(nom: "", annee: "2023", nbrJours: 0, idBenevoles: [], isClosed: false)
    
    @State var dateTemp = Date.now
    
    var intent : FestivalIntent = FestivalIntent()
    //@ObservedObject var festivalVM : FestivalViewModel

    
    @State private var festivalFormFailedMessage : String?
    @State private var selected: [Bool] = [false, false, false]
    
    var dateFormatter = DateFormatter()
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2023, month: 3, day: 31)
        let endComponents = DateComponents(year: 2025, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
    @State private var isLinkActive = true

    
    init() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        // French Locale (fr_FR)
        dateFormatter.locale = Locale(identifier: "fr_FR")
        // print(dateFormatter.string(from: date)) // 2 janv. 2001
    }

        
    var body: some View {
        // debugPrint(dateFormatter.string(from: newDate))
        VStack {
            
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
                    DatePicker(
                        "",
                        selection: $dateTemp,
                        in: dateRange,
                        displayedComponents: [.date]
                    )
                }
                .padding([.horizontal], 20)
                
                HStack {
                    Text("Nombre de jour")
                    TextField("nbrJours", value: $newFestival.nbrJours, format: .number)
                        /*.keyboardType(.numberPad)
                        .onChange(of: $jours) { newValue in
                            if newValue < 1 {
                                $newFestival.nbrJours = 1
                                self.nbrJourFailedMessage = "Le festival doit avoir au moins 1 jour"
                            } else if newValue > 31 {
                                $newFestival.nbrJours = 31
                            }
                        }*/
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
                    Text(self.festivalFormFailedMessage ?? "")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .italic()
                }
                .padding([.horizontal], 20)
               
             
            }
            
            Spacer()
            HStack {
                Spacer()
                Button("Créer ce festival") {
                    debugPrint(newFestival.nom)
                    debugPrint(Date.now)
                    debugPrint(newFestival.annee)
                    debugPrint(newFestival.nbrJours)
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
}
/*
struct FestivalFormView_Previews: PreviewProvider {
    static var previews: some View {
        FestivalFormAdminView()
    }
}
*/
