//
//  FestivalFormView.swift
//  FestiFun
//
//  Created by etud on 30/03/2023.
//

import SwiftUI

struct FestivalFormAdminView: View {
    
    @State private var festivalFormFailedMessage : String?
    //var date : Date = Date.now
    //@State private var newFestival: Festival = Festival(nom: "", annee: date, nbrJours: 0, idBenevoles: [], isClosed: false)
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var selected: [Bool] = [false, false, false, false]
    
    var body: some View {
        VStack {
            /*
            Text("Inscription")
                .font(.title)
                .fontWeight(.bold)
            Text("Formulaire d'inscription en bénévole sur l'App FestiFun,")
                .font(.footnote)
            Text("tous les champs doivent être rempli")
                .font(.footnote)
            Spacer()
            
            VStack {
                HStack {
                    Text("Nom")
                    TextField("nom", text: $newBenevole.nom)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[0] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false, false, false]
                            selected[0] = true
                        }
                }
                .padding([.horizontal], 20)
                
                HStack {
                    Text("Prénom")
                    TextField("prenom", text: $newBenevole.prenom)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[1] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false, false, false]
                            selected[1] = true
                        }
                }
                .padding([.horizontal], 20)
                
                HStack {
                    Text("Email")
                    TextField("email", text: $newBenevole.email)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[2] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false, false, false]
                            selected[2] = true
                        }
                }
                .padding([.horizontal], 20)
                
                HStack {
                    Text("Mot de passe")
                    SecureField("mot de passe", text: $newBenevole.password)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selected[3] ? Color.green : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selected = [false, false, false, false]
                            selected[3] = true
                        }
                }
                .padding([.horizontal], 20)
             
            }
            
            Spacer()
            HStack {
                Spacer()
                Button("Créer votre compte") {
                    Task {
                        
                        switch await BenevoleDAO.shared.registerBenevole(benevole: newBenevole){
                        case .success(let benevole):
                            loggedBenevole.email = benevole.email
                            loggedBenevole.nom = benevole.nom
                            loggedBenevole.prenom = benevole.prenom
                            loggedBenevole.isAdmin = benevole.isAdmin
                            loggedBenevole.isAuthenticated = true
                            
                        case .failure(let error):
                            switch(error){
                            case HttpError.unauthorized :
                                self.registerFailedMessage = "Vous ne pouvez créer ce compte"
                            default :
                                self.registerFailedMessage = "Erreur de connexion " + error.localizedDescription
                            }
                            print(error)
                         
                        }
                    }
                }
                .padding(10)
                .background(Color.salmon)
                .foregroundColor(.white)
                .cornerRadius(8)
                Text(festivalFormFailedMessage ?? "")
                    .foregroundColor(.red)
             
            }
             */
        }
        .listStyle(.plain)
        .padding()
    }
}
/*
struct FestivalFormView_Previews: PreviewProvider {
    static var previews: some View {
        FestivalFormAdminView()
    }
}
*/
