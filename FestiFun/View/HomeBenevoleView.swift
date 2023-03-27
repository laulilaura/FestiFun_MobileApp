//
//  HomeBenevoleView.swift
//  FestiFun
//
//  Created by Laura on 26/03/2023.
//

import SwiftUI

struct HomeBenevoleView: View {
    
    @StateObject var loggedBenevole: LoggedBenevole
    
    var body: some View {
        VStack {
            Text("Bienvenue "+loggedBenevole.prenom)
                .font(.title)
                .fontWeight(.bold)
            Text("Tu es connecté avec le compte : "+loggedBenevole.email)
                .font(.footnote)
            Image("benevole")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.bottom,30)
            
            Spacer().frame(height: 10)
            VStack {
                Text("Bienvenue à FestiFun, l'application vous permettant de gérer vos bénévolats sur des festivals. Vous pourrez ainsi retrouver tous les festivals auquels vous êtes déjà inscrit mais également en découvrir de nouveaux et pourquoi pas y apporter votre aide !")
                Text("N'hésitez pas, tout le monde n'attends que vous")
            }
            
            Spacer().frame(height: 10)
            Text("Liste des festivals auquel vous êtes bénévole")
                .font(.title2)
            VStack{
            }.task {
                // Récupérer la liste des festivals où iel est bénévole, sinon afficher un texte : "vous ne participez pas encore à un festival (+bouton vers affectation ?)
            }
            
        }
    }
}

/*struct HomeBenevoleView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBenevoleView()
    }
}
*/
