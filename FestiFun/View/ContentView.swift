//
//  ContentView.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import SwiftUI

struct ContentView: View {
    
    //@StateObject var loggedBenevole: LoggedBenevole = LoggedBenevole(nom: "", prenom: "", email: "", isAdmin: false, isAuthenticated: false)
    
    // ADMIN CONNECTE
    @StateObject var loggedBenevole: LoggedBenevole = LoggedBenevole(nom: "laura", prenom: "corentin", email: "A@g.de", isAdmin: true, isAuthenticated: true)
    
    // BENEVOLE CONNECTE
    //@StateObject var loggedBenevole: LoggedBenevole = LoggedBenevole(id: "64205c86855ca5dea27e3cf6", nom: "corentin", prenom: "Clement", email: "corentinclement1@gmail.com", isAdmin: false, isAuthenticated: true)
    
    var body: some View {
        
        if loggedBenevole.isAdmin && loggedBenevole.isAuthenticated {
            NavigationAdminView()
                .transition(.opacity)
                .environmentObject(loggedBenevole)
        }
        else if loggedBenevole.isAuthenticated {
            NavigationBenevoleView()
                .transition(.opacity)
                .environmentObject(loggedBenevole)
        } else {
            AuthentificationView().transition(.opacity).environmentObject(loggedBenevole)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
