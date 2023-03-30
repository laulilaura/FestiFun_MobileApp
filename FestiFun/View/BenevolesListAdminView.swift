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
    @State var benevoles: [Benevole] = []
    
    var body: some View {
        VStack {
            Text("Liste de bénévole")
        }
    }
}

/*
struct BenevolesListAdminView_Previews: PreviewProvider {
    static var previews: some View {
        BenevolesListAdminView(loggedBenevole: loggedBenevole)
    }
}
*/
