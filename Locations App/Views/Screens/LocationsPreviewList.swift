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
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            HStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(dateLocations.descendingKeys.indexed(), id: \.1.self) { i, dateComponent in
                            //                if location.arrivalDate.fullMonthWithYear != self.currentDate.fullMonthWithYear {
                            //                    self.currentDate = location.arrivalDate
                            //                }
                            HStack(alignment: .center) {
                                DaySideBar(date: dateComponent.date)
                                DayPreviewBlock(locations: self.dateLocations[dateComponent]!, isFilled: self.isFilled(index: i))
                            }
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private func isFilled(index: Int) -> Bool {
        index % 2 == 0
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsPreviewList(locations: Location.previewLocations).statusBar(hidden: true)
    }
}
