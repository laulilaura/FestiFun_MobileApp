//
//  CreateBenevoleView.swift
//  FestiFun
//
//  Created by etud on 28/03/2023.
//

import SwiftUI

struct CreateBenevoleView: View {
    
    /*
     @Published var nom: String
     @Published var prenom: String
     @Published var email: String
     @Published var password: String
     */
    
    //@Binding var isPresented: Benevole?
    /*@ObservedObject var viewModel: BenevoleFormViewModel
    private var intent: BenevoleIntent
    
    
    //init(benevoleVM: BenevoleFormViewModel, intent: BenevoleIntent, isPresented: Binding<Benevole?>){
    init(benevoleVM: BenevoleFormViewModel, intent: BenevoleIntent){

        self.viewModel = benevoleVM
        self.intent = intent
        self.intent.addObserver(benevoleFormViewModel: benevoleVM)
    }
    */
    
    @State private var loginFailedMessage : String?
    @State private var newBenevole: Benevole = Benevole(nom: "", prenom: "", email: "", password: "", isAdmin: false)
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    //self.isPresented = nil
                }) {
                    Text("Annuler")
                }
            }
            .padding()
            //self.loginFailedMessage = $viewModel.error
            List {
                HStack {
                    Text("Nom")
                    Divider()
                    TextField("Nom", text: $newBenevole.nom)
                        //.onSubmit {
                        //    intent.intentToChange(nom: newBenevole.nom)
                        //}
                }
                
                HStack {
                    Text("Email")
                    Divider()
                    TextField("Email", text: $newBenevole.email)
                        //.onSubmit {
                        //    intent.intentToChange(email: viewModel.email)
                        //}
                }
                
                HStack {
                    Text("Mot de passe")
                    Divider()
                    SecureField("Mot de passe", text: $newBenevole.password)
                        //.onSubmit {
                        //    intent.intentToChange(password: viewModel.password)
                        //}
                }
                /*
                 HStack {
                 Text("Admin")
                 Toggle(isOn: $viewModel.isAdmin) {
                 
                 }.onSubmit {
                 intent.intentToChange(isAdmin: viewModel.isAdmin)
                 }
                 }
                 */
                
                HStack {
                    Spacer()
                    Button("Créer un bénévole") {
                        Task {
                            switch await BenevoleDAO.shared.createBenevole(benevole: newBenevole){
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
                            /*
                            intent.intentToChange(isAdmin: false)
                            await intent.intentToCreate(benevole: viewModel.modelCopy)
                            if let error = viewModel.error {
                                print(error)
                            } else {
                                self.isPresented = nil
                            }
                            */
                        }
                    }
                }
            }
            .listStyle(.plain)
            .padding()
        }
    }
}

/*
struct CreateBenevoleView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBenevoleView(benevoleVM: BenevoleFormViewModel(model: MockData.benevole), intent: BenevoleIntent(), isPresented: .constant(MockData.benevole))
    }
}
*/
