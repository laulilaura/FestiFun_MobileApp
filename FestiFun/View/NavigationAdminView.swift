//
//  NavigationAdminView.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import SwiftUI

struct NavigationAdminView: View {
    
    @StateObject var loggedBenevole: LoggedBenevole

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
                BenevolesListAdminView(loggedBenevole: loggedBenevole)
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
struct NavigationAdminView_Previews: PreviewProvider {
    static var previews: some View {
        var loggedBenevole: LoggedBenevole = LoggedBenevole(nom: "Benaiton", prenom: "Laura", email: "laura@gmail.com", isAdmin: false, isAuthenticated: false)
        
        NavigationAdminView(loggedBenevole: loggedBenevole)
    }
}
*/
