//
//  AuthentificationView.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import SwiftUI

struct AuthentificationView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var loginFailedMessage : String?
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    @State private var benevoleToCreate: Benevole?
    
    //var viewModel: BenevoleFormViewModel
    //var intent: BenevoleIntent
    
    var body: some View {
        
        NavigationStack(){
            Spacer()
            VStack {
                Text("Bienvenue à FestiFun !")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Connexion à votre compte utilisateur ou admin")
                    .font(.footnote)
                Image("jeu-de-cartes")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.bottom,30)
                
                Group{
                    TextField("email",text :$email)
                        .padding()
                        .cornerRadius(5.0)
                        .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.salmon, lineWidth: 1)
                            )
                    
                }
                .padding([.horizontal], 20)
                
                
                SecureField("Mot de passe", text: $password)
                    .padding()
                    .cornerRadius(5.0)
                    .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.salmon, lineWidth: 1)
                        )
                    .padding([.horizontal, .bottom], 20)
                
                Button("Connexion") {
                    Task {
                        switch await BenevoleDAO.shared.login(email: email, password: password) {
                        
                        case .success(let benevole):
                                loggedBenevole.email = benevole.email
                                loggedBenevole.nom = benevole.nom
                                loggedBenevole.prenom = benevole.prenom
                                loggedBenevole.isAdmin = benevole.isAdmin
                                loggedBenevole.isAuthenticated = true
                        case .failure(let error):
                            switch(error){
                            case HttpError.unauthorized :
                                self.loginFailedMessage = "Mauvais identifiants de connexion"
                            default :
                                self.loginFailedMessage = "Erreur de connexion " + error.localizedDescription
                            }
                            print(error)
                        }
                    }
                }
                .padding(10)
                .background(Color.salmon)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Text(loginFailedMessage ?? "")
                    .foregroundColor(.red)
                
                Spacer()
                HStack {
                    Text("Pas de comtpte ? ")
                                        .foregroundColor(.black)
                    NavigationLink(destination:
                                   RegisterBenevoleView()){
                        Text("Inscris toi").foregroundColor(Color.salmon)
                    }
                }
                
            }
            .padding()
        }
    }
}
/*
struct AuthentificationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthentificationView()
    }
}
*/
