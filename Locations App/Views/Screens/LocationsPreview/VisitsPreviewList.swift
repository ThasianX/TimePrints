//
//  LocationsView.swift
//  Locations App
//
//  Created by Kevin Li on 1/30/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct VisitsPreviewList: View {
    @State private var showingDetail = false
    @State private var currentDateComponent = Date().dateComponents
    let visits: [Visit]
    
    private var dateVisits: [DateComponents: [Visit]] {
        Dictionary(grouping: visits, by: { $0.arrivalDate.dateComponents })
    }
    
    private var monthDates: [DateComponents: [DateComponents]] {
        Dictionary(grouping: Array(dateVisits.keys), by: { $0.monthAndYear })
    }
    
    var body: some View {
        var fill = false
        
        func isFilled() -> Bool {
            fill.toggle()
            return fill
        }
        
        return ZStack {
            SuperColor(UIColor.black)
            
            DayDetailsView(show: $showingDetail, date: currentDateComponent.date, visits: dateVisits[currentDateComponent] ?? [])
                .frame(width: showingDetail ? nil : 0, height: showingDetail ? nil : 0)
                .animation(.easeIn)
            
            ScrollView(.vertical, showsIndicators: false) {
                V0Stack {
                    ForEach(monthDates.descendingKeys) { monthComponent in
                        H0Stack {
                            MonthYearSideBar(date: monthComponent.date).offset(x: self.showingDetail ? -200 : 0)
                            V0Stack {
                                ForEach(self.monthDates[monthComponent]!.sortDescending) { dateComponent in
                                    HStack {
                                        DaySideBar(date: dateComponent.date)
                                            .offset(x: self.showingDetail ? -200 : 0)
                                        DayPreviewBlock(visits: self.dateVisits[dateComponent]!, isFilled: isFilled())
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

struct VisitsPreviewList_Previews: PreviewProvider {
    static var previews: some View {
        VisitsPreviewList(visits: Visit.previewVisits).statusBar(hidden: true)
    }
}
