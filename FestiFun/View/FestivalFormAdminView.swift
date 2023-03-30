//
//  FestivalFormView.swift
//  FestiFun
//
//  Created by etud on 29/03/2023.
//

import SwiftUI

struct FestivalFormAdminView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    var intent: FestivalIntent = FestivalIntent()

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

/*
struct FestivalFormView_Previews: PreviewProvider {
    static var previews: some View {
        var loggedBenevole: LoggedBenevole = LoggedBenevole(nom: "Benaiton", prenom: "Laura", email: "laura@gmail.com", isAdmin: true, isAuthenticated: true)
        FestivalFormView(loggedBenevole: loggedBenevole)
    }
}
*/
