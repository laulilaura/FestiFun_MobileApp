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
                Text("C'est un compte ")
                Text("administrateur").foregroundColor(Color.salmon)
                Text(" !")
            }
            Spacer().frame(height: 30)
            Image("admin")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.bottom,30)
            
            Spacer()
            VStack {
                Text("Bienvenue à FestiFun, l'application vous permettant de gérer la gestion des festivals.")
                Text("Ici, il vous est possible de :").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Créer des bénévoles").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Créer des festivals").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Créer des zones de festival").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Créer des créneaux de festival").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Affecter des bénévoles à des créneau").frame(maxWidth: .infinity, alignment: .leading)
                Text("      - Afficher tous les existants").frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            Spacer()
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
