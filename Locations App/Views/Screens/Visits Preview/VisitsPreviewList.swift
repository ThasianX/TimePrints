import SwiftUI

struct VisitsPreviewList: View {
    @FetchRequest(entity: Visit.entity(), sortDescriptors: []) var visits: FetchedResults<Visit>
    @State private var currentDayComponent = DateComponents()
    
    private var visitsForDayComponent: [DateComponents: [Visit]] {
        Dictionary(grouping: visits, by: { $0.arrivalDate.dateComponents })
    }
    
    private var daysComponentsForMonthComponent: [DateComponents: [DateComponents]] {
        Dictionary(grouping: Array(visitsForDayComponent.keys), by: { $0.monthAndYear })
    }
    
    private var isPreviewActive: Bool {
        currentDayComponent == DateComponents()
    }
    
    private var descendingMonthComponents: [DateComponents] {
        daysComponentsForMonthComponent.descendingKeys
    }
    
    var body: some View {
        var fill = false
        
        func isFilled() -> Bool {
            fill.toggle()
            return fill
        }
        
        return ZStack {
            backgroundColor
            
            VScroll {
                V0Stack {
                    ForEach(descendingMonthComponents) { monthComponent in
                        H0Stack {
                            MonthYearSideBar(date: monthComponent.date)
                            V0Stack {
                                ForEach(self.descendingDayComponents(for: monthComponent)) { dayComponent in
                                    HStack {
                                        DaySideBar(date: dayComponent.date)
                                        DayPreviewBlock(
                                            currentDayComponent: self.$currentDayComponent,
                                            visits: self.visitsForDayComponent[dayComponent]!,
                                            isFilled: isFilled(),
                                            dayComponent: dayComponent,
                                            isPreviewActive: self.isPreviewActive
                                        )
                                    }
                                    .frame(height: 150)
                                }
                            }
                        }
                    }
                }
            }
            .extendToScreenEdges()
            
            VisitsForDayView(currentDayComponent: $currentDayComponent, visits: visitsForDayComponent[currentDayComponent] ?? [])
                .scaleEffect(isPreviewActive ? 0 : 1)
                .fade(isPreviewActive)
                .animation(.easeIn)
        }
    }
}

// MARK: - Helpers
private extension VisitsPreviewList {
    private func isActiveDayComponent(dayComponent: DateComponents) -> Bool {
        return currentDayComponent == dayComponent
    }
    
    private func descendingDayComponents(for monthComponent: DateComponents) -> [DateComponents] {
        daysComponentsForMonthComponent[monthComponent]!.sortDescending
    }
}

// MARK: - Content
private extension VisitsPreviewList {
    private var backgroundColor: some View {
        ScreenColor(UIColor.black)
    }
}

struct VisitsPreviewList_Previews: PreviewProvider {
    static var previews: some View {
        VisitsPreviewList().environment(\.managedObjectContext, CoreData.stack.context).statusBar(hidden: true)
    }
}
