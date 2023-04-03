//
//  AffectationFestivalBenevoleView.swift
//  FestiFun
//
//  Created by Laura on 02/04/2023.
//

import SwiftUI

struct AffectationFestivalBenevoleView: View {
    
    @EnvironmentObject var loggedBenevole: LoggedBenevole
    
    @ObservedObject var festVM : FestivalViewModel
    @ObservedObject var jourLVM : JourListViewModel = JourListViewModel()
    @ObservedObject var zoneLVM : ZoneListViewModel = ZoneListViewModel()
    
    var intentFestival : FestivalIntent = FestivalIntent()
    var intentJour : JourIntent = JourIntent()
    var intentZone : ZoneIntent = ZoneIntent()
    
    
    @State var errorMessage : String = ""
    @State var errorMessageJour : String = ""
    @State var selectedZonesIndex : [String] =  [String](repeating: "", count: 30)

    
    // Trouver un moyen d'initialiser avant mais pose problème
    @State var isChecked: [Bool] = [Bool](repeating: false, count: 30)

    @Environment(\.dismiss) var dismiss
    
    let columns = [
            GridItem(.fixed(100)),
            GridItem(.flexible()),
        ]
    
    @State var count: Int = 0
    
    init(festVM: FestivalViewModel) {
        self.festVM = festVM
    }
    
    var body: some View {
        VStack {
            Text("Festival")
                .font(.title)
                .fontWeight(.bold)
            Text(festVM.nom)
                .font(.title)
            Image("rejoindre")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80, alignment: .center)
            Text("Informations sur le festival:")
                .font(.footnote)
            LazyVGrid(columns: columns, spacing: 10) {
                Text("Année : ").frame(maxWidth: .infinity, alignment: .leading)
                Text(festVM.annee).foregroundColor(Color.salmon).frame(maxWidth: .infinity, alignment: .leading)
                Text("Nombre de jours : ").frame(maxWidth: .infinity, alignment: .leading)
                Text("\(festVM.nbrJours)").foregroundColor(Color.salmon).frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 40)
            if self.festVM.isClosed {
                Text("Le festival est actuellement fermé, tu ne peux pas t'affecter") // Ne devrait jamais arriver
            } else {
                ScrollView {
                    ForEach(Array(jourLVM.jours.enumerated().reversed()), id: \.element.id) { index, jour in
                        HStack {
                            VStack {
                                Text(jour.nom)
                                Text(jour.date)
                                HStack {
                                    Text(jour.debutHeure)
                                    Text(jour.finHeure)
                                }
                            }.onAppear {
                                Task {
                                    debugPrint("index :")
                                    debugPrint(index)
                                    
                                }
                            }
                            VStack {
                                Text("Choisissez une zone :")
                                
                                Picker("Zones", selection: $selectedZonesIndex[index]) {
                                    ForEach(zoneLVM.zones, id: \.self.id){ zone in
                                        Text(zone.nom)
                                    }
                                }
                            }
                            
                            Toggle(isOn: $isChecked[index]) {
                                Text("Case")
                            }
                             
                            
                        }
                    }
                }
                .padding()
                
                Text(self.errorMessage ?? "")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .italic()
                Button("S'inscrire à ce festival") {
                    Task {
                        for j in 0...isChecked.count-1 {
                            debugPrint(j)
                            //await intentCreneau.shared.getCreneauByJourId(id: <#T##String#>)
                            if (isChecked[j]) {
                                // Rcupérer le creneau lié
                                let tabBenevole : [String] = ["benevole1"]
                                switch await AffectationDAO.shared.createAffectation(affectation: Affectation(idBenevoles: tabBenevole, idCreneau: "lala", idZone: selectedZonesIndex[j], idFestival: festVM.id!)) {
                                case .failure(let error):
                                    errorMessage = "erreur à la création \(error)"
                                case .success(let affect):
                                    errorMessage = "bien \(affect)"
                                }
                            }
                        }
                    }
                }
                .padding(10)
                .background(Color.salmon)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            
            // les VStack permmettent de séléctionner un jour et une zone (select parmis ceux existant) (si même jour devenir disable ?)
            // Activer l'affectation à la fin
        }
        .onAppear {
            Task {
                intentJour.addObserver(jourListViewModel: jourLVM)
                await intentJour.intentToGetAllByFestival(festivalId: festVM.id! )
                if jourLVM.error != nil {
                    errorMessageJour = "Erreur : \(jourLVM.error ?? "Erreur au chargement")"
                } else {
                    isChecked = [Bool](repeating: false, count: jourLVM.jours.count)
                }
                intentZone.addObserver(zoneListViewModel: zoneLVM)
                await intentZone.intentToGetAllByFestival(festivalId: festVM.id!)
                if zoneLVM.error != nil {
                    errorMessageJour = "Erreur : \(zoneLVM.error ?? "Erreur au chargement")"
                } else {
                    for i in 0...zoneLVM.zones.count-1 {
                        selectedZonesIndex[i] = zoneLVM.zones[i].id!
                    }
                }
                
                /*
                    async let addZoneObserver = intentZone.addObserver(zoneListViewModel: zoneLVM)
                    async let addJourObserver = intentJour.addObserver(jourListViewModel: jourLVM)
                await [addZoneObserver, addJourObserver]
                    await intentZone.intentToGetAllByFestival(festivalId: festVM.id!)
                debugPrint("111111")
                await intentJour.intentToGetAllByFestival(festivalId: festVM.id! )
                if jourLVM.error != nil {
                    errorMessageJour = "Erreur : \(jourLVM.error ?? "Erreur au chargement")"
                } else {
                    self.isChecked = [Bool](repeating: false, count: self.jourLVM.jours.count)
                }
                debugPrint("22222")
                debugPrint(jourLVM.jours.count)
                debugPrint("prout")
//                await [getZones, getJours]
                debugPrint("dans la fin")

                debugPrint(self.jourLVM.jours)
                debugPrint(self.zoneLVM.zones)
                debugPrint(self.jourLVM.jours.count)*/
            }
        }
    }
}
