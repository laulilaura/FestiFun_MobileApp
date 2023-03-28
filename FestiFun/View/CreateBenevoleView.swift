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
    
    @Binding var isPresented: Benevole?
    @ObservedObject var viewModel: BenevoleFormViewModel
    private var intent: BenevoleIntent
    
    @State private var loginFailedMessage : String?
    
    init(benevoleVM: BenevoleFormViewModel, intent: BenevoleIntent, isPresented: Binding<Benevole?>){
        self.viewModel = benevoleVM
        self._isPresented = isPresented
        self.intent = intent
        self.intent.addObserver(benevoleFormViewModel: benevoleVM)
    }
    
    var columns = [GridItem(.adaptive(minimum: 300))]
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented = nil
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
                    TextField("Nom", text: $viewModel.nom)
                        .onSubmit {
                            intent.intentToChange(nom: viewModel.nom)
                        }
                }
                
                HStack {
                    Text("Email")
                    Divider()
                    TextField("Email", text: $viewModel.email)
                        .onSubmit {
                            intent.intentToChange(email: viewModel.email)
                        }
                }
                
                HStack {
                    Text("Mot de passe")
                    Divider()
                    SecureField("Mot de passe", text: $viewModel.password)
                        .onSubmit {
                            intent.intentToChange(password: viewModel.password)
                        }
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
                            intent.intentToChange(isAdmin: false)
                            await intent.intentToCreate(benevole: viewModel.modelCopy)
                            if let error = viewModel.error {
                                print(error)
                            } else {
                                self.isPresented = nil
                            }
                            
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
