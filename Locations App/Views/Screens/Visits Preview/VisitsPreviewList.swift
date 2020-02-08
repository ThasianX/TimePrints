//
//  LocationsView.swift
//  Locations App
//
//  Created by Kevin Li on 1/30/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct VisitsPreviewList: View {
    @State private var currentDayComponent = DateComponents()
    let visits: [Visit]
    
    private var visitsForDayComponent: [DateComponents: [Visit]] {
        Dictionary(grouping: visits, by: { $0.arrivalDate.dateComponents })
    }
    
    private var daysComponentsForMonthComponent: [DateComponents: [DateComponents]] {
        Dictionary(grouping: Array(visitsForDayComponent.keys), by: { $0.monthAndYear })
    }
    
    private var isPreviewActive: Bool {
        currentDayComponent == DateComponents()
    }
    
    var body: some View {
        var fill = false
        
        func isFilled() -> Bool {
            fill.toggle()
            return fill
        }
        
        return ZStack {
            SuperColor(UIColor.black)
            
            //            DayDetailsView(show: $showingDetail, date: currentDateComponent.date, visits: dateVisits[currentDateComponent] ?? [])
            //                .frame(width: showingDetail ? nil : 0, height: showingDetail ? nil : 0)
            //                .animation(.easeIn)
            
            ScrollView(.vertical, showsIndicators: false) {
                V0Stack {
                    ForEach(daysComponentsForMonthComponent.descendingKeys) { monthComponent in
                        H0Stack {
                            MonthYearSideBar(date: monthComponent.date)
                            V0Stack {
                                ForEach(self.daysComponentsForMonthComponent[monthComponent]!.sortDescending) { dayComponent in
                                    HStack {
                                        DaySideBar(date: dayComponent.date)
                                        GeometryReader { geometry in
                                            ZStack {
                                                DayPreviewBlock(currentDayComponent: self.$currentDayComponent, visits: self.visitsForDayComponent[dayComponent]!, isFilled: isFilled(), dayComponent: dayComponent, isPreviewActive: self.isPreviewActive)
                                                .offset(y: self.isActiveDayComponent(dayComponent: dayComponent) ? -geometry.frame(in: .global).minY : 0)
                                                .scaleEffect(self.isActiveDayComponent(dayComponent: dayComponent) ? 1 : 0.5)
                                            }
                                        }
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

// MARK: - Helpers
private extension VisitsPreviewList {
    private func isActiveDayComponent(dayComponent: DateComponents) -> Bool {
        return currentDayComponent == dayComponent
    }
}

struct VisitsPreviewList_Previews: PreviewProvider {
    static var previews: some View {
        VisitsPreviewList(visits: Visit.previewVisits).environment(\.managedObjectContext, CoreData.stack.context).statusBar(hidden: true)
    }
}
