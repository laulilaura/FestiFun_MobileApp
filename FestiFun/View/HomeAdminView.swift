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
            Text("Admin page home")
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
