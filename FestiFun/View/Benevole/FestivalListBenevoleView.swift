//
//  FestivalListBenevoleView.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import SwiftUI

struct FestivalListBenevoleView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    var intentFestival: FestivalIntent = FestivalIntent()
    
    @ObservedObject var festivalsVM: FestivalListViewModel = FestivalListViewModel()
    
    var body: some View {
        VStack {
            if (festivalsVM.error != nil) {
                Text(festivalsVM.error!).foregroundColor(.red)
            } else {
                if(festivalsVM.festivals.isEmpty){
                    Text("Il n'existe pas encore de festival").italic()
                } else {
                    ForEach(festivalsVM.festivals, id: \.id) { festival in
                        VStack(alignment: .leading) {
                            Text(festival.nom).bold()
                            Text(festival.annee).italic()
                        }.padding()
                        .cornerRadius(5.0)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.lightyellow, lineWidth: 1)
                            .background(Color.lightyellow)
                            .frame(width: 280, height: 60)
                        )
                    }
                }
            }
        }
        .onAppear {
            Task {
                await intentFestival.intentToGetAll()
            }
        }
    }
}

/*
struct FestivalListBenevoleView_Previews: PreviewProvider {
    static var previews: some View {
        var loggedBenevole: LoggedBenevole = LoggedBenevole(nom: "Benaiton", prenom: "Laura", email: "laura@gmail.com", isAdmin: false, isAuthenticated: false)
        
        FestivalListBenevoleView(loggedBenevole: loggedBenevole)
    }
}
*/
