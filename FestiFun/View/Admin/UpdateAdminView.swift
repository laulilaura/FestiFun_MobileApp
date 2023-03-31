//
//  UpdateAdminView.swift
//  FestiFun
//
//  Created by etud on 30/03/2023.
//

import SwiftUI

struct UpdateAdminView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    let columns = [
        GridItem(.fixed(80)),
        GridItem(.flexible()),
    ]
    
    @State var nom : String
    @State var prenom : String
    @State var email : String

    @State private var mdp1 = ""
    @State private var mdp2 = ""


    
    var intent : BenevoleIntent = BenevoleIntent()
    //@ObservedObject var benevoleVM = BenevoleFormViewModel(loggedBenevole)
    
    var body: some View {
        
        VStack {
            Spacer().frame(height: 20)
            Text("Modification des informations personnelles")
                .font(.footnote)
            Spacer()
            LazyVGrid(columns: columns, spacing: 20) {
                Text("Nom : ").frame(maxWidth: .infinity, alignment: .leading)
                TextField("Nom", text: $nom)
                    .padding()
                    .cornerRadius(5.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    
                Text("Prénom : ").frame(maxWidth: .infinity, alignment: .leading)
                TextField("prenom", text: $prenom)
                    .padding()
                    .cornerRadius(5.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text("Email : ").frame(maxWidth: .infinity, alignment: .leading)
                TextField("email", text: $email)
                    .padding()
                    .cornerRadius(5.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text("Mot de passe : ").frame(maxWidth: .infinity, alignment: .leading)
                TextField("mdp1", text: $mdp1)
                    .padding()
                    .cornerRadius(5.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("").frame(maxWidth: .infinity, alignment: .leading)
                TextField("mdp2", text: $mdp2)
                    .padding()
                    .cornerRadius(5.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 40)
            Spacer().frame(height: 50)
            Button("Modifier vos information personnelles") {
                Task {
                    let nomWV = $nom.wrappedValue
                    // ENLEVER LES IF ET APPELER L'INTENT AVEC LA VM EN PARAMETRES
                    
                    if(loggedBenevole.nom != nomWV && nomWV != "") {
                        //await intent.intentToChange(nom: $nom) {
                            // Vérifier que le VM à bien changé
                        //}
                        debugPrint("nomChange")
                    }
                    let prenomWV = $prenom.wrappedValue
                    if(loggedBenevole.prenom != prenomWV && prenomWV != "") {
                        //await intent.intentToChange(prenom: $prenom) {
                            // Vérifier que le VM à bien changé
                        //}
                        debugPrint("prenomChange")
                    }
                    let emailWV = $email.wrappedValue
                    if(loggedBenevole.email != emailWV && emailWV != "") {
                        //await intent.intentToChange(email: $email) {
                            // Vérifier que le VM à bien changé
                        //}
                        debugPrint("emailChange")
                    }
                    let mdp1WV = $mdp1.wrappedValue
                    let mdp2WV = $mdp2.wrappedValue
                    if(mdp1WV == mdp2WV && mdp1WV != "") {
                        //await intent.intentToChange(password: $password) {
                            // Vérifier que le VM à bien changé
                        //}
                        debugPrint("mdpChange")
                    }
                    
                }
            }
            .padding(10)
            .background(Color.salmon)
            .foregroundColor(.white)
            .cornerRadius(8)
            Spacer()
        }
    }
}
/*
struct UpdateAdminView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAdminView()
    }
}

*/
