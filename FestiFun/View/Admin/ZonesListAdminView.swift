//
//  ZoneListAdminView.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import SwiftUI

struct ZoneListAdminView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole

    var intent: ZoneIntent = ZoneIntent()

    private var idFestival: String

    @ObservedObject var zoneLVM: ZoneListViewModel = ZoneListViewModel()
    
    
    init(idFestival: String) {
        self.idFestival = idFestival
    }
    
    var body: some View {
        VStack {
            Text("Gestion des zones")
                .font(.title)
                .fontWeight(.bold)
            
            NavigationLink(destination: ZoneFormAdminView()){
                Image(systemName: "plus.app.fill")
            }
            
            if zoneLVM.error != nil {
                Text(zoneLVM.error!).foregroundColor(.red)
            } else {
                if(zoneLVM.zones.isEmpty){
                    Text("Il n'existe pas encore de zone").italic()
                } else {
                  
                    ForEach(zoneLVM.zones, id: \.id) { zone in
                        NavigationLink(destination : UpdateZoneAdminView(zone : ZoneFormViewModel(model: zone))){
                                VStack(alignment: .leading) {
                                    Text(zone.nom).bold()
                                    Text("\(zone.nbBenevolesNecessaires)").italic()
                                    Text("\(zone.nbBenevolesActuels)").italic()
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
        }
        .onAppear {
            Task {
                await intent.intentToGetAll(idFestival: self.idFestival)
            }
        }
    }
}
/*
struct ZoneListAdminView_Previews: PreviewProvider {
    static var previews: some View {
        var loggedBenevole: LoggedBenevole = LoggedBenevole(nom: "Benaiton", prenom: "Laura", email: "laura@gmail.com", isAdmin: true, isAuthenticated: true)

        ZoneListAdminView(loggedBenevole: loggedBenevole)
    }
}
*/
