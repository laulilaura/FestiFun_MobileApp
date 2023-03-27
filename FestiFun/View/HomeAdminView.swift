//
//  HomeAdminView.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import SwiftUI

struct HomeAdminView: View {
    
    @StateObject var loggedBenevole: LoggedBenevole
    
    @State var errorMessage = ""
    @State var benevoles: [Benevole] = []
    
    var body: some View {
        VStack {
            if !errorMessage.isEmpty {
                Text(errorMessage).foregroundColor(.red)
            } else {
                if(benevoles.isEmpty){
                    Text("Il n'existe pas encore de bénévole").italic()
                } else {
                    ForEach(benevoles, id: \.id) { benevole in
                        VStack(alignment: .leading) {
                            Text(benevole.nom).bold()
                            Text(benevole.email).italic()
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
                switch await BenevoleDAO.shared.getAllBenevole() {
                case .failure(let error):
                    errorMessage = "Erreur : \(error.localizedDescription)"
                case .success(let benevoles):
                    self.benevoles = benevoles
                }
            }
        }
    }
}
/*

struct HomeAdminView_Previews: PreviewProvider {
    static var previews: some View {
        HomeAdminView(loggedBenevole : loggedBenevole)
    }
}
*/
