//
//  BenevolesListAdminView.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import SwiftUI

struct BenevolesListAdminView: View {
    
    @StateObject var loggedBenevole: LoggedBenevole
    
    @State var errorMessage = ""
    @State var benevoles: [Benevole] = []
    
    var body: some View {
        TabView{
            NavigationView{
                HomeAdminView(loggedBenevole: loggedBenevole)
            }
            .tabItem{
                Image(systemName: "house")
                Text("Home")
            }
            .tint(Color("salmon"))
            
            NavigationView{
                FestivalListBenevoleView(loggedBenevole: loggedBenevole)
                    .navigationTitle("Bénévoles")
            }
            .tabItem{
                Image(systemName: "person.3.fill")
                Text("Bénévoles")
            }
            
            
            NavigationView{
                FestivalListBenevoleView(loggedBenevole: loggedBenevole)
                    .navigationTitle("Gestion des festivals")
            }
            .tabItem{
                Image(systemName: "signpost.right.and.left.fill")
                Text("Festivals")
            }
            
            
            NavigationView{
                HomeAdminView(loggedBenevole: loggedBenevole)
                    .navigationTitle("Paramètres")
            }
            .tabItem{
                Image(systemName: "person.circle")
                Text("Paramètres")
            }
        }
        .accentColor(.salmon)
    }
}

/*
struct BenevolesListAdminView_Previews: PreviewProvider {
    static var previews: some View {
        BenevolesListAdminView(loggedBenevole: loggedBenevole)
    }
}
*/
