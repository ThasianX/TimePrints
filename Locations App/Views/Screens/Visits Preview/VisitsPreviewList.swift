import SwiftUI
import Mapbox

struct VisitsPreviewList: View {
    @FetchRequest(entity: Visit.entity(), sortDescriptors: []) var visits: FetchedResults<Visit>
    @State private var currentDayComponent = DateComponents()
    @State private var isPreviewActive = true
    @Binding var showingVisitsPreviewList: Bool
    @Binding var activeVisitLocation: Location?
    
    private var visitsForDayComponent: [DateComponents: [Visit]] {
        Dictionary(grouping: visits, by: { $0.arrivalDate.dateComponents })
    }
    
    private var daysComponentsForMonthComponent: [DateComponents: [DateComponents]] {
        Dictionary(grouping: Array(visitsForDayComponent.keys), by: { $0.monthAndYear })
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
                        self.monthYearSideBarWithDayPreviewBlocksView(monthComponent: monthComponent, isFilled: isFilled)
                    }
                }
                .frame(width: screen.width)
            }
            .extendToScreenEdges()
            
            overlayColor
                .fade(isPreviewActive)
            
            visitsForActiveDayView
        }
    }
}

private extension VisitsPreviewList {
    private func descendingDayComponents(for monthComponent: DateComponents) -> [DateComponents] {
        daysComponentsForMonthComponent[monthComponent]!.sortDescending
    }

    private func setActiveVisitLocationAndDisplayMap(visit: Visit) {
        self.activeVisitLocation = visit.location
        self.showingVisitsPreviewList = false
    }
}

private extension VisitsPreviewList {
    private var overlayColor: some View {
        ScreenColor(Color("salmon"))
            .saturation(2)
    }
    
    private var backgroundColor: some View {
        ScreenColor(UIColor.black)
    }
    
    private func monthYearSideBarWithDayPreviewBlocksView(monthComponent: DateComponents, isFilled: @escaping () -> Bool) -> some View {
        H0Stack {
            self.monthYearSideBarText(date: monthComponent.date)
            V0Stack {
                ForEach(self.descendingDayComponents(for: monthComponent)) { dayComponent in
                    self.daySideBarWithPreviewBlockView(dayComponent: dayComponent, isFilled: isFilled())
                }
            }
        }
    }
    
    private func monthYearSideBarText(date: Date) -> some View {
        MonthYearSideBar(date: date)
    }
    
    private func daySideBarWithPreviewBlockView(dayComponent: DateComponents, isFilled: Bool) -> some View {
        HStack {
            daySideBarText(date: dayComponent.date)
            dayPreviewBlockView(dayComponent: dayComponent, isFilled: isFilled)
        }
        .frame(height: 150)
    }
    
    private func daySideBarText(date: Date) -> some View {
        DaySideBar(date: date)
    }
    
    private func dayPreviewBlockView(dayComponent: DateComponents, isFilled: Bool) -> some View {
        DayPreviewBlock(
            currentDayComponent: $currentDayComponent,
            isPreviewActive: $isPreviewActive,
            visits: visitsForDayComponent[dayComponent]!.sortAscByArrivalDate,
            isFilled: isFilled,
            dayComponent: dayComponent
        )
    }
    
    private var visitsForActiveDayView: some View {
        VisitsForDayView(
            currentDayComponent: $currentDayComponent,
            isPreviewActive: $isPreviewActive,
            visits: visitsForDayComponent[currentDayComponent]?.sortAscByArrivalDate ?? [],
            setActiveVisitLocationAndDisplayMap: setActiveVisitLocationAndDisplayMap
        )
            .fade(isPreviewActive)
            .scaleEffect(isPreviewActive.when(true: 0.1, false: 1))
            .animation(.spring())
    }
}

struct VisitsPreviewList_Previews: PreviewProvider {
    static var previews: some View {
        VisitsPreviewList(showingVisitsPreviewList: .constant(false), activeVisitLocation: .constant(nil)).environment(\.managedObjectContext, CoreData.stack.context).statusBar(hidden: true)
    }
}