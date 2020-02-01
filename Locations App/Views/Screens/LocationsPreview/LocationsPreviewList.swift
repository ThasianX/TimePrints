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
        ZStack {
            SuperColor(.black)
            
            ScrollView(.vertical, showsIndicators: false) {
                V0Stack {
                    ForEach(monthAndDates.descendingKeys.indexed(), id: \.1.self) { i, monthComponent in
                        H0Stack {
                            MonthYearSideBar(date: monthComponent.date)
                            V0Stack {
                                ForEach(self.monthAndDates[monthComponent]!.sortDescending.indexed(), id: \.1.self) { i, dateComponent in
                                    HStack {
                                        DaySideBar(date: dateComponent.date)
                                        DayPreviewBlock(locations: self.dateLocations[dateComponent]!, isFilled: self.isFilled(index: i))
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
    
    private func isFilled(index: Int) -> Bool {
        return index % 2 == 0
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsPreviewList(locations: Location.previewLocations).statusBar(hidden: true)
    }
}
