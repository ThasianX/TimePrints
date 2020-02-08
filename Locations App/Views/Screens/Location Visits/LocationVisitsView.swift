//
//  LocationVisitsview.swift
//  Locations App
//
//  Created by Kevin Li on 2/5/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct LocationVisitsView: View {
    @FetchRequest var visitsForSelectedLocation: FetchedResults<Visit>
    @Binding var show: Bool
    let selectedLocation: Location?
    
    init(show: Binding<Bool>, selectedLocation: Location?) {
        self._show = show
        self.selectedLocation = selectedLocation
        
        let locationExists = selectedLocation != nil
        self._visitsForSelectedLocation = FetchRequest(
            entity: Visit.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Visit.arrivalDate, ascending: false)
            ],
            predicate: locationExists ? NSPredicate(format: "%@ == location", selectedLocation!) : nil
        )
    }
    
    var body: some View {
        VStack {
            Text("Visits for \(selectedLocation?.name ?? "")")
                .font(.headline)
                .padding(.bottom, 8)
            
            ForEach(visitsForSelectedLocation) { visit in
                VStack(alignment: .leading) {
                    HStack {
                        Text(visit.visitDuration)
                        Spacer()
                        if visit.isFavorite {
                            Image(systemName: "star.fill")
                                .imageScale(.medium)
                                .foregroundColor(.yellow)
                        }
                    }
                    Text(visit.arrivalDate.abbreviatedMonthWithDayAndYear)
                        .font(.caption)
                }
            }
            Spacer()
            BImage(perform: { self.show = false }, image: .init(systemName: "x.circle.fill"))
        }
        .padding()
    }
}

struct LocationVisitsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationVisitsView(show: .constant(true), selectedLocation: .preview).environment(\.managedObjectContext, CoreData.stack.context)
    }
}
