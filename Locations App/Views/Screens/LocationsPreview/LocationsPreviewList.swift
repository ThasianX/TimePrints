//
//  LocationsView.swift
//  Locations App
//
//  Created by Kevin Li on 1/30/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct LocationsPreviewList: View {
    @State private var showingDetail = false
    @State private var currentDateComponent = Date().dateComponents
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
            
            DayDetailsView(show: $showingDetail, date: currentDateComponent.date, locations: dateLocations[currentDateComponent] ?? []).frame(width: showingDetail ? nil : 0, height: showingDetail ? nil : 0).animation(.easeIn)
            
            ScrollView(.vertical, showsIndicators: false) {
                V0Stack {
                    ForEach(monthAndDates.descendingKeys) { monthComponent in
                        H0Stack {
                            MonthYearSideBar(date: monthComponent.date).offset(x: self.showingDetail ? -200 : 0)
                            V0Stack {
                                ForEach(self.monthAndDates[monthComponent]!.sortDescending) { dateComponent in
                                    HStack {
                                        DaySideBar(date: dateComponent.date).offset(x: self.showingDetail ? -200 : 0)
                                        DayPreviewBlock(locations: self.dateLocations[dateComponent]!, isFilled: isFilled())
                                            .onTapGesture {
                                                withAnimation {
                                                    self.showingDetail = true
                                                    self.currentDateComponent = dateComponent
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .opacity(showingDetail ? 0 : 1)
            .beyond()
        }
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsPreviewList(locations: Location.previewLocations).statusBar(hidden: true)
    }
}
