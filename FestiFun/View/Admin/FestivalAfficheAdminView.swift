//
//  FestivalAfficheAdminView.swift
//  FestiFun
//
//  Created by Laura bg on 02/04/2023.
//

import SwiftUI

struct FestivalAfficheAdminView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    @ObservedObject var festVM : FestivalViewModel
    
    @ObservedObject var joursLVM: JourListViewModel = JourListViewModel()
    @ObservedObject var zoneLVM: ZoneListViewModel = ZoneListViewModel()
    
    @State var indexFest : Int
    
    @State var intentFestival : FestivalIntent = FestivalIntent()
    @State var intentJour : JourIntent = JourIntent()
    @State var intentZone : ZoneIntent = ZoneIntent()
    
    @State var errorMessage : String = ""
    @State var errorMessageJour : String = ""
    @State var errorMessageZone : String = ""
    
    @Environment(\.dismiss) var dismiss
    
    let columns = [
            GridItem(.fixed(80)),
            GridItem(.flexible()),
        ]
    
    var body: some View {
        NavigationStack {
                Text("Festival")
                    .font(.title)
                    .fontWeight(.bold)
                Text(festVM.nom)
                    .font(.title)
                Image("scene")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.bottom,30)
                Text("Informations :")
                    .font(.footnote)
                LazyVGrid(columns: columns, spacing: 20) {
                    Text("Année : ").frame(maxWidth: .infinity, alignment: .leading)
                    Text(festVM.annee).foregroundColor(Color.salmon).frame(maxWidth: .infinity, alignment: .leading)
                    Text("Nombre de jours : ").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(festVM.nbrJours)").foregroundColor(Color.salmon).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 40)
                if(festVM.isClosed){
                    Text("Ce festival est fermé.")
                }
                //Spacer()
                Button(action: { }) {
                    NavigationLink(destination: UpdateFestivalAdminView(fest: festVM )){
                        Text("Modifier ce festival")
                    }
                }
                .padding(10)
                .background(Color.salmon)
                .foregroundColor(.white)
                .cornerRadius(8)
            
                NavigationStack() {
                if !errorMessageJour.isEmpty {
                    Text(errorMessageJour).foregroundColor(.red)
                } else {
                    ScrollView {
                        ForEach(Array(joursLVM.jours.enumerated()), id: \.element.id) { index, jour in
                            //NavigationLink(destination : FestivalAfficheAdminView(festVM : FestivalViewModel(model: jour), indexJour : index)){ // Modifier jours ?
                                    VStack(alignment: .leading) {
                                        Text("Nom du jour : "+jour.nom).bold()
                                        Text("Date : "+jour.date).italic()
                                        }.padding()
                                        .cornerRadius(5.0)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.lightyellow, lineWidth: 1)
                                            .background(Color.lightyellow)
                                            .frame(width: 360, height: 60)
                                        )
                                //}
                        }
                    }
                    .frame(width: 400)
                    .padding()
                }
                
                if !errorMessageZone.isEmpty {
                    Text(errorMessageZone).foregroundColor(.red)
                } else {
                    ScrollView {
                        ForEach(Array(zoneLVM.zones.enumerated()), id: \.element.id) { index, zone in
                            //NavigationLink(destination : FestivalAfficheAdminView(festVM : FestivalViewModel(model: jour), indexJour : index)){ // Modifier jours ?
                                    VStack(alignment: .leading) {
                                        Text("Nom de la zone : "+zone.nom).bold()
                                        Text("Nombre de bénévoles nécessaires : \(zone.nbBenevolesNecessaires)").italic()
                                        Text("Nombre de bénévoles actuellement : \(zone.nbBenevolesActuels)").italic()
                                        }.padding()
                                        .cornerRadius(5.0)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.lightyellow, lineWidth: 1)
                                            .background(Color.lightyellow)
                                            .frame(width: 360, height: 60)
                                        )
                                //}
                        }
                    }
                    .frame(width: 400)
                    .padding()
                }

                Text(errorMessage).foregroundColor(.red)
            
                Button("Supprimer ce festival") {
                    Task {
                        intentFestival.addObserver(festivalFormViewModel: festVM)
                        await intentFestival.intentToDelete(festivalId: festVM.id!, festivalIndex: indexFest)
                        if festVM.error != nil {
                            errorMessage = "Erreur : \(festVM.error)"
                        } else {
                            dismiss()
                        }
                    }
                }
                .padding(10)
                .background(Color.lightgrey)
                .foregroundColor(.red)
                .cornerRadius(8)
                
            }
        }
        .onAppear {
            Task {
                intentJour.addObserver(jourListViewModel: joursLVM)
                await intentJour.intentToGetAllByFestival(festivalId: festVM.id! )
                if joursLVM.error != nil {
                    errorMessageJour = "Erreur : \(joursLVM.error ?? "Erreur au chargement")"
                }
                intentZone.addObserver(zoneListViewModel: zoneLVM)
                await intentZone.intentToGetAllByFestival(zoneId: festVM.id!)
                if zoneLVM.error != nil {
                    errorMessageJour = "Erreur : \(zoneLVM.error ?? "Erreur au chargement")"
                }
            }
        }
    }
}
