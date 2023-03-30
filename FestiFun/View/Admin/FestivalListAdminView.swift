//
//  FestivalListAdminView.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import SwiftUI

struct FestivalListAdminView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    @State var errorMessage = ""
    @State var festivals: [Festival] = []
    
    var body: some View {
        VStack {
            Text("Gestion des festivals")
                .font(.title)
                .fontWeight(.bold)
            // ENLEVER LE BACK CAR JUSTE DANS LA VUE PAS NOUVELLE PAGE MACHIN ???
            NavigationLink(destination: //CreateBenevoleView(benevoleVM: viewModel, intent: intent) ){
                //CreateBenevoleView(benevoleVM: BenevoleFormViewModel(model: self.$userToCreate), intent: self.intent){
                           FestivalFormAdminView()){
                Image(systemName: "plus.app.fill")
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage).foregroundColor(.red)
            } else {
                if(festivals.isEmpty){
                    Text("Il n'existe pas encore de festival").italic()
                } else {
                    ForEach(festivals, id: \.id) { festival in
                        VStack(alignment: .leading) {
                            Text(festival.nom).bold()
                            Text(festival.annee, style: .date).italic()
                        }.padding()
                        .cornerRadius(5.0)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.lightyellow, lineWidth: 1)
                            .background(Color.lightyellow)
                            .frame(width: 280, height: 60)
                        )
                    }
                }
            }
        }
        .onAppear {
            Task {
                switch await FestivalDAO.shared.getAllFestival() {
                case .failure(let error):
                    errorMessage = "Erreur : \(error.localizedDescription)"
                case .success(let festivals):
                    self.festivals = festivals
                }
            }
        }
    }
}
/*
struct FestivalListAdminView_Previews: PreviewProvider {
    static var previews: some View {
        var loggedBenevole: LoggedBenevole = LoggedBenevole(nom: "Benaiton", prenom: "Laura", email: "laura@gmail.com", isAdmin: true, isAuthenticated: true)

        FestivalListAdminView(loggedBenevole: loggedBenevole)
    }
}
*/
