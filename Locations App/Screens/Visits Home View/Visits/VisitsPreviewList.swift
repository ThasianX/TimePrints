import SwiftUI
import Mapbox

struct VisitsPreviewList: View {
    @FetchRequest(entity: Visit.entity(), sortDescriptors: []) var visits: FetchedResults<Visit>
    @State private var currentDayComponent = DateComponents()
    @State private var isPreviewActive = true
    @Binding var showingHomeView: Bool
    @Binding var activeVisitLocation: Location?
    @Binding var hideFAB: Bool

    var body: some View {
        var fill = false

        func isFilled() -> Bool {
            fill.toggle()
            return fill
        }

        return ZStack {
            V0Stack {
                leftAlignedHeader
                visitsPreviewList(isFilled: isFilled)
                    .extendToScreenEdges()
            }

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
    private var leftAlignedHeader: some View {
        HStack {
            headerText
            Spacer()
        }
        .padding()
    }

    private var headerText: some View {
        Text("Visits")
            .font(.largeTitle)
            .foregroundColor(.white)
    }
}

private extension VisitsPreviewList {
    private var overlayColor: some View {
        ScreenColor(.init(.salmon))
            .saturation(1.5)
    }
}

private extension VisitsPreviewList {
    private var visitsForDayComponent: [DateComponents: [Visit]] {
        Dictionary(grouping: visits, by: { $0.arrivalDate.dateComponents })
    }

    private var daysComponentsForMonthComponent: [DateComponents: [DateComponents]] {
        Dictionary(grouping: Array(visitsForDayComponent.keys), by: { $0.monthAndYear })
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
            monthYearSideBarText(date: monthComponent.date)
            V0Stack {
                ForEach(descendingDayComponents(for: monthComponent)) { dayComponent in
                    self.daySideBarWithPreviewBlockView(dayComponent: dayComponent, isFilled: isFilled())
                }
            }
        }
    }

    private func monthYearSideBarText(date: Date) -> MonthYearSideBar {
        MonthYearSideBar(date: date, color: .init(.salmon))
    }

    private func descendingDayComponents(for monthComponent: DateComponents) -> [DateComponents] {
        daysComponentsForMonthComponent[monthComponent]!.sortDescending
    }

    private func daySideBarWithPreviewBlockView(dayComponent: DateComponents, isFilled: Bool) -> some View {
        HStack {
            daySideBarView(date: dayComponent.date)
            dayPreviewBlockView(dayComponent: dayComponent, isFilled: isFilled)
        }
        .frame(height: 150)
    }

    private func daySideBarView(date: Date) -> DaySideBar {
        DaySideBar(date: date)
    }

    private func dayPreviewBlockView(dayComponent: DateComponents, isFilled: Bool) -> DayPreviewBlock {
        DayPreviewBlock(
            currentDayComponent: $currentDayComponent,
            isPreviewActive: $isPreviewActive,
            hideFAB: $hideFAB,
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
            hideFAB: $hideFAB,
            visits: visitsForDayComponent[currentDayComponent]?.sortAscByArrivalDate ?? [],
            setActiveVisitLocationAndDisplayMap: setActiveVisitLocationAndDisplayMap
        )
    }

    private func setActiveVisitLocationAndDisplayMap(visit: Visit) {
        self.activeVisitLocation = visit.location
        self.showingHomeView = false
    }
}

struct VisitsPreviewList_Previews: PreviewProvider {
    static var previews: some View {
        VisitsPreviewList(showingHomeView: .constant(true), activeVisitLocation: .constant(nil), hideFAB: .constant(false))
            .environment(\.managedObjectContext, CoreData.stack.context)
            .statusBar(hidden: true)
    }
}

