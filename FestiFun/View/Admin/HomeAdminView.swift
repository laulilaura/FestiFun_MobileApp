//
//  HomeAdminView.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import SwiftUI

struct HomeAdminView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    @State var errorMessage = ""
    @State var benevoles: [Benevole] = []
    
    var body: some View {
        VStack {
            Text("Bienvenue "+loggedBenevole.prenom+" "+loggedBenevole.nom)
                .font(.title)
                .fontWeight(.bold)
            Text("Tu es connecté avec le compte : "+loggedBenevole.email)
                .font(.footnote)
            Spacer().frame(height: 20)
            HStack {
                Text("Vous êtes connecté à un compte")
                Text("administrateur").foregroundColor(Color.salmon)
            }
            Spacer()
            Image("admin")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.bottom,30)
            
            Spacer()
            VStack (spacing: 12) {
                Text("Bienvenue à FestiFun, l'application vous permettant de gérer des festivals.")
                Text("Ici, il vous est possible de :").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Supprimer des bénévoles").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Créer et modifier des festivals").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Créer des zones de festival").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Créer des jours de festival").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Afficher tous les existants").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Modifier tes informations").frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            Spacer()
            Text("© 2023, “FestiFun, tous droits réservés”").font(.footnote)
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
