//
//  ParametresAdminView.swift
//  FestiFun
//
//  Created by etud on 30/03/2023.
//

import SwiftUI

struct ParametresAdminView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    let columns = [
            GridItem(.fixed(80)),
            GridItem(.flexible()),
        ]
    
    var body: some View {
        VStack {
            NavigationStack() {
                Text("Paramètres")
                    .font(.title)
                    .fontWeight(.bold)
                Image("parametres")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.bottom,30)
                //Spacer()
                Text("Vos informations personnelles :")
                    .font(.footnote)
                Spacer()
                LazyVGrid(columns: columns, spacing: 20) {
                    Text("Nom : ").frame(maxWidth: .infinity, alignment: .leading)
                    Text(loggedBenevole.nom).foregroundColor(Color.salmon).frame(maxWidth: .infinity, alignment: .leading)
                    Text("Prénom : ").frame(maxWidth: .infinity, alignment: .leading)
                    Text(loggedBenevole.prenom).foregroundColor(Color.salmon).frame(maxWidth: .infinity, alignment: .leading)
                    Text("Mail : ").frame(maxWidth: .infinity, alignment: .leading)
                    Text(loggedBenevole.email).foregroundColor(Color.salmon).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 40)
                HStack {
                    Text("Vous êtes ")
                    Text("administrateur").foregroundColor(Color.salmon)
                    Text(" sur l'app FestiFun.")
                }
                //Spacer(minLength: 40)
                Spacer()
                Button(action: { }) {
                    NavigationLink(destination: UpdateAdminView(nom: loggedBenevole.nom, prenom: loggedBenevole.prenom, email: loggedBenevole.email)){
                        Text("Modifier vos information personnelles")
                    }
                }
                .padding(10)
                .background(Color.salmon)
                .foregroundColor(.white)
                .cornerRadius(8)
                //Spacer(minLength: 40)
                Text(" ")
                Button("Déconnexion") {
                    Task {
                        loggedBenevole.nom = ""
                        loggedBenevole.prenom = ""
                        loggedBenevole.email = ""
                        loggedBenevole.isAdmin = false
                        loggedBenevole.isAuthenticated = false
                    }
                }
                .padding(10)
                .background(Color.lightgrey)
                .foregroundColor(.red)
                .cornerRadius(8)
                //Spacer()
            }
        }
    }
}

/*
struct ParametresAdminView_Previews: PreviewProvider {
    static var previews: some View {
    //let loggedBenevole: LoggedBenevole = LoggedBenevole(nom: "Benaiton", prenom: "Laura", email: "laura@gmail.com", isAdmin: false, isAuthenticated: false)
        
        ParametresAdminView()
    }
}
*/
