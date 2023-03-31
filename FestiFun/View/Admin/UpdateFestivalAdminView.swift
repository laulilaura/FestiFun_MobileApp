//
//  UpdateFestivalAdminView.swift
//  FestiFun
//
//  Created by etud on 31/03/2023.
//

import SwiftUI

struct UpdateFestivalAdminView: View {
    
    @ObservedObject var fest : FestivalViewModel
    
    init(fest: FestivalViewModel) {
        self.fest = fest
    }
    
    var body: some View {
        VStack {
            Text(fest.annee)
        }
    }
}
