//
//  LocationsView.swift
//  Locations App
//
//  Created by Kevin Li on 1/30/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct LocationsPreviewList: View {
    let locations: [Location]
    
    private var dateLocations: [DateComponents: [Location]] {
        Dictionary(grouping: locations, by: { $0.arrivalDate.dateComponents })
    }
    
    private var monthAndDates: [DateComponents: [DateComponents]] {
        Dictionary(grouping: Array(dateLocations.keys), by: { $0.monthAndYear })
    }
    
    var body: some View {
        var fill = false
        
        func isFilled() -> Bool {
            fill.toggle()
            return fill
        }
        
        return ZStack {
            SuperColor(.black)
            
            ScrollView(.vertical, showsIndicators: false) {
                V0Stack {
                    ForEach(monthAndDates.descendingKeys) { monthComponent in
                        H0Stack {
                            MonthYearSideBar(date: monthComponent.date)
                            V0Stack {
                                ForEach(self.monthAndDates[monthComponent]!.sortDescending) { dateComponent in
                                    HStack {
                                        DaySideBar(date: dateComponent.date)
                                        DayPreviewBlock(locations: self.dateLocations[dateComponent]!, isFilled: isFilled())
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .beyond()
        }
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsPreviewList(locations: Location.previewLocations).statusBar(hidden: true)
    }
}
