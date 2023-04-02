//
//  FestivalListAdminView.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import SwiftUI

struct FestivalListBenevoleView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    @State var errorMessage = ""
    @ObservedObject var festivalLVM: FestivalListViewModel = FestivalListViewModel()
    
    @State var intentFestival : FestivalIntent = FestivalIntent()
    
    var body: some View {
        VStack {
            Text("Festivals disponibles")
                .font(.title)
                .fontWeight(.bold)
            Image("festival")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.bottom,30)
            if !self.festivalLVM.loading {
                if !errorMessage.isEmpty {
                    Text(errorMessage).foregroundColor(.red)
                } else {
                    if(festivalLVM.festivals.isEmpty){
                        Text("Il n'existe pas encore de festival").italic()
                    } else {
                        ScrollView {
                            ForEach(Array(festivalLVM.festivals.enumerated()), id: \.element.id) { index, festival in
                                NavigationLink(destination : AffectationFestivalBenevoleView(festVM : FestivalViewModel(model: festival))){
                                    HStack{
                                        VStack (alignment: .leading) {
                                            Text(festival.nom).bold()
                                            Text(festival.annee).italic()
                                        }
                                        Image(systemName: "person.fill.badge.plus")
                                    }.padding()
                                        .cornerRadius(5.0)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.lightyellow, lineWidth: 1)
                                                .background(Color.lightyellow)
                                                .frame(width: 360, height: 60)
                                        )
                                        .disabled(festival.isClosed)
                                }
                            }
                        }
                        .frame(width: 400)
                        .padding()
                    }
                }
            } else {
                ProgressView("Chargement en cours")
            }
        }
        .onAppear {
            Task {
                intentFestival.addObserver(festivalListViewModel: festivalLVM)
                await intentFestival.getFestivalsNewByBenevole(benevoleId: loggedBenevole.id!)
                if festivalLVM.error != nil {
                    errorMessage = "Erreur : \(festivalLVM.error ?? "Erreur au chargement de la liste")"
                }
            }
        }
    }
    
    // Revoir comment gérer avec les horaires en fonction du festival créer une page
    /*
    func rejoindre(festival: festival) {
        debugPrint(festival)
    }
     */
}
