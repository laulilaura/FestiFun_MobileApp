//
//  BenevolesListAdminView.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import SwiftUI

struct BenevolesListAdminView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    
    @State var errorMessage = ""
    
    @ObservedObject var benevoleLVM: BenevoleListViewModel = BenevoleListViewModel()
    
    var intentBenevole : BenevoleIntent = BenevoleIntent()
    
    var body: some View {
        VStack {
            Text("Liste des bénévoles")
                .font(.title)
                .fontWeight(.bold)
            ScrollView {
                if !errorMessage.isEmpty {
                    Text(errorMessage).foregroundColor(.red)
                } else {
                    if(benevoleLVM.benevoles.isEmpty){
                        Text("Il n'existe pas encore de benevole").italic()
                    } else {
                        ForEach(Array(benevoleLVM.benevoles.enumerated()), id: \.element.id) { index, benevole in
                            HStack {
                                VStack(alignment: .leading) {
                                    if(benevole.isAdmin) {
                                        Text("Utilisateur admin").font(.footnote)
                                    }
                                    Text("\(benevole.nom) \(benevole.prenom)").bold()
                                    Text(benevole.email).italic()
                                }
                                Button(action: { Task {
                                        do {
                                            await self.delete(benevole: benevole, index: index)
                                        }
                                }})
                                {
                                    Image(systemName: "xmark.bin.circle.fill")
                                }
                            }
                            .padding()
                            .cornerRadius(5.0)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.lightyellow, lineWidth: 1)
                                    .background(Color.lightyellow)
                                    .frame(width: 300, height: 75)
                            )
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                switch await BenevoleDAO.shared.getAllBenevole() {
                case .failure(let error):
                    errorMessage = "Erreur : \(error.localizedDescription)"
                case .success(let benevoles):
                    self.benevoleLVM.benevoles = benevoles
                }
                intentBenevole.addObserver(benevoleListViewModel: benevoleLVM)
            }
        }
    }
    
    
    func delete(benevole: LoggedBenevole, index: Int) async {
        await intentBenevole.intentToDelete(benevoleId: benevole.id!, benevoleIndex: index)
    }
    
}


/*
struct BenevolesListAdminView_Previews: PreviewProvider {
    static var previews: some View {
        BenevolesListAdminView(loggedBenevole: loggedBenevole)
    }
}
*/
