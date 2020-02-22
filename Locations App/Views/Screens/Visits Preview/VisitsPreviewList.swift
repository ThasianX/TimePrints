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

    var body: some View {
        var fill = false
        
        func isFilled() -> Bool {
            fill.toggle()
            return fill
        }
        
        return ZStack {
            backgroundColor

            visitsPreviewList(isFilled: isFilled)
                .extendToScreenEdges()
            
            overlayColor
                .fade(if: isPreviewActive)
            
            visitsForActiveDayView
                .fade(if: isPreviewActive)
                .scaleEffect(isPreviewActive ? 0 : 1)
                .animation(.spring())
        }
    }
}

private extension VisitsPreviewList {
    private var backgroundColor: some View {
        ScreenColor(UIColor.black)
    }

    private var overlayColor: some View {
        ScreenColor(Color("salmon"))
            .saturation(2)
    }
}

private extension VisitsPreviewList {
    private func visitsPreviewList(isFilled: @escaping () -> Bool) -> some View {
        VScroll {
            visitsPreviewStack(isFilled: isFilled)
                .frame(width: screen.width)
        }
    }

    private var descendingMonthComponents: [DateComponents] {
        daysComponentsForMonthComponent.descendingKeys
    }

    private func visitsPreviewStack(isFilled: @escaping () -> Bool) -> some View {
        V0Stack {
            ForEach(descendingMonthComponents) { monthComponent in
                self.monthYearSideBarWithDayPreviewBlocksView(monthComponent: monthComponent, isFilled: isFilled)
            }
        }
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

    private func descendingDayComponents(for monthComponent: DateComponents) -> [DateComponents] {
        daysComponentsForMonthComponent[monthComponent]!.sortDescending
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
}

private extension VisitsPreviewList {
    private var visitsForActiveDayView: some View {
        VisitsForDayView(
            currentDayComponent: $currentDayComponent,
            isPreviewActive: $isPreviewActive,
            visits: visitsForDayComponent[currentDayComponent]?.sortAscByArrivalDate ?? [],
            setActiveVisitLocationAndDisplayMap: setActiveVisitLocationAndDisplayMap
        )
    }

    private func setActiveVisitLocationAndDisplayMap(visit: Visit) {
        self.activeVisitLocation = visit.location
        self.showingVisitsPreviewList = false
    }
}

struct VisitsPreviewList_Previews: PreviewProvider {
    static var previews: some View {
        VisitsPreviewList(showingVisitsPreviewList: .constant(false), activeVisitLocation: .constant(nil)).environment(\.managedObjectContext, CoreData.stack.context).statusBar(hidden: true)
    }
}
