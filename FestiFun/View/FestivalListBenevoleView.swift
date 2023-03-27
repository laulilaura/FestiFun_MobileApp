//
//  FestivalListBenevoleView.swift
//  FestiFun
//
//  Created by etud on 27/03/2023.
//

import SwiftUI

struct FestivalListBenevoleView: View {
    
    @State var errorMessage = ""
    @State var festivals: [Festival] = []
    
    var body: some View {
        VStack {
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

struct FestivalListBenevoleView_Previews: PreviewProvider {
    static var previews: some View {
        FestivalListBenevoleView()
    }
}
