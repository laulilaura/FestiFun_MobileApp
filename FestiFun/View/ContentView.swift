//
//  ContentView.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var loggedBenevole: LoggedBenevole = LoggedBenevole(nom: "", prenom: "", email: "", isAdmin: false, isAuthenticated: false)
    
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
