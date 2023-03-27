//
//  NavigationBenevoleView.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import SwiftUI

struct NavigationBenevoleView: View {
    
    @StateObject var loggedBenevole: LoggedBenevole
    
    var body: some View {
        TabView{
            NavigationView{
                HomeBenevoleView(loggedBenevole: loggedBenevole)
            }
            .tabItem{
                Image(systemName: "house")
                Text("Home")
            }
            .tint(Color("salmon"))
            
            NavigationView{
                FestivalListBenevoleView(loggedBenevole: loggedBenevole)
                    .navigationTitle("Découvrir")
            }
            .tabItem{
                Image(systemName: "figure.and.child.holdinghands")
                Text("Découvrir")
            }
            
            
            NavigationView{
                HomeAdminView(loggedBenevole: loggedBenevole)
                    .navigationTitle("Festival")
            }
            .tabItem{
                Image(systemName: "figure.walk.arrival")
                Text("Festival")
            }
            
            
            NavigationView{
                HomeAdminView(loggedBenevole: loggedBenevole)
                    .navigationTitle("Rejoindre")
            }
            .tabItem{
                Image(systemName: "rectangle.and.hand.point.up.left.fill")
                Text("Rejoindre")
            }
            
            
            NavigationView{
                HomeAdminView(loggedBenevole: loggedBenevole)
                    .navigationTitle("Utilisateur")
            }
            .tabItem{
                Image(systemName: "person.circle")
                Text("Utilisateur")
            }
        }
        .accentColor(.salmon)
    }
}

struct NavigationBenevoleView_Previews: PreviewProvider {
   
    static var previews: some View {
        var loggedBenevole: LoggedBenevole = LoggedBenevole(nom: "Benaiton", prenom: "Laura", email: "laura@gmail.com", isAdmin: false, isAuthenticated: false)
        
        NavigationBenevoleView(loggedBenevole: loggedBenevole)
    }
}
