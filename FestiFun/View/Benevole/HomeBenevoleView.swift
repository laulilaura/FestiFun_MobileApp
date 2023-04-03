//
//  HomeBenevoleView.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import SwiftUI

struct HomeBenevoleView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    @State var errorMessage = ""
    @ObservedObject var festivalLVM: FestivalListViewModel = FestivalListViewModel()
    
    @State var intentFestival : FestivalIntent = FestivalIntent()
    
    var body: some View {
        VStack {
            Text("Bienvenue "+loggedBenevole.prenom)
                .font(.title)
                .fontWeight(.bold)
            Text("Tu es connecté avec le compte : "+loggedBenevole.email)
                .font(.footnote)
            Image("benevole")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.bottom,30)
            
            Spacer().frame(height: 10)
            VStack {
                Text("Bienvenue à FestiFun, l'application vous permettant de gérer vos bénévolats sur des festivals. Vous pourrez ainsi retrouver tous les festivals auquels vous êtes déjà inscrit mais également en découvrir de nouveaux et pourquoi pas y apporter votre aide !")
                Text("N'hésitez pas, tout le monde n'attends que vous")
            }
            
            Spacer().frame(height: 10)
            Text("Liste des festivals auquel vous êtes bénévole").font(.title2)
            if !errorMessage.isEmpty {
                Text(errorMessage).foregroundColor(.red)
            } else {
                if(festivalLVM.festivals.isEmpty){
                    Text("Vous n'êtes encore affecté à aucun festival").italic()
                } else {
                    ScrollView {
                        ForEach(Array(festivalLVM.festivals.enumerated()), id: \.element.id) { index, festival in
                                    VStack(alignment: .leading) {
                                        Text(festival.nom).bold()
                                        Text(festival.annee).italic()
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
                    .frame(width: 400)
                    .padding()
                }
            }
            
        }
        .onAppear {
            Task {
                intentFestival.addObserver(festivalListViewModel: festivalLVM)
                await intentFestival.intentToGetAllByBenevole(benevoleId: loggedBenevole.id!)
                if festivalLVM.error != nil {
                    errorMessage = "Erreur : \(festivalLVM.error ?? "Erreur au chargement de la liste")"
                }
            }
        }
    }
}

/*struct HomeBenevoleView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBenevoleView()
    }
}
*/
