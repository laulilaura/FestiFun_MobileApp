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
    
    @State var indexFest : Int
    
    @State var intentFestival : FestivalIntent = FestivalIntent()
    @State var intentJour : JourIntent = JourIntent()
    
    @State var errorMessage : String = ""
    @State var errorMessageJour : String = ""
    
    @Environment(\.dismiss) var dismiss
    
    let columns = [
            GridItem(.fixed(80)),
            GridItem(.flexible()),
        ]
    
    var body: some View {
        VStack {
            NavigationStack() {
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
                //Spacer()
                Text("Informations :")
                    .font(.footnote)
                //Spacer()
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
                
                if !errorMessage.isEmpty {
                    Text(errorMessage).foregroundColor(.red)
                } else {
                    ScrollView {
                        ForEach(Array(joursLVM.jours.enumerated()), id: \.element.id) { index, jour in
                            //NavigationLink(destination : FestivalAfficheAdminView(festVM : FestivalViewModel(model: jour), indexJour : index)){ // Modifier jours ?
                                    VStack(alignment: .leading) {
                                        Text(jour.nom).bold()
                                        Text(jour.date).italic()
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

            
                
                //Spacer()
                Text(errorMessage).foregroundColor(.red)
                Button("Supprimer ce festival") {
                    Task {
                        /*
                        intentJour.addObserver(jourListViewModel: joursLVM)
                        await intentJour.intentToDeleteByFestival(id: festVM.id)
                        if joursLVM.error != nil {
                            errorMessageJour = "Erreur : \(joursLVM.error)"
                        } else {
                            //Mettre le reste du code là
                        }
                        */
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
                
                //Spacer(minLength: 40)
                //Text(" ")
            }
        }
        .onAppear {
            Task {
                intentJour.addObserver(jourListViewModel: joursLVM)
                await intentJour.intentToGetAllByFestivalId(festivalId: festVM.id! )
                if joursLVM.error != nil {
                    errorMessageJour = "Erreur : \(joursLVM.error)"
                }
            }
        }
    }
}

/*
struct FestivalAfficheAdminView_Previews: PreviewProvider {
    static var previews: some View {
        FestivalAfficheAdminView()
    }
}
*/
