import SwiftUI
import Mapbox

struct VisitsPreviewList: View {
    @Environment(\.appTheme) private var appTheme: UIColor

    @FetchRequest(entity: Visit.entity(), sortDescriptors: []) var visits: FetchedResults<Visit>

    @State private var currentDayComponent = DateComponents()
    @State private var isPreviewActive = true

    @Binding var hideFAB: Bool
    @ObservedObject var appState: AppState

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

            visitsForActiveDayView
                .fade(if: isPreviewActive)
                .scaleEffect(isPreviewActive ? 0.5 : 1)
                .animation(.spring())
        }
    }
}

private extension VisitsPreviewList {
    private var leftAlignedHeader: some View {
        HStack {
            headerText
                .padding(.leading)
            Spacer()
        }
        .padding()
    }

    private var headerText: some View {
        Text("Visits")
            .font(.largeTitle)
            .foregroundColor(appTheme.color)
    }
}

private extension VisitsPreviewList {
    private var visitsForDayComponent: [DateComponents: [Visit]] {
        Dictionary(grouping: visits, by: { $0.arrivalDate.dateComponents })
    }

    private var daysComponentsForMonthComponent: [DateComponents: [DateComponents]] {
        Dictionary(grouping: Array(visitsForDayComponent.keys), by: { $0.monthAndYear })
    }

    private var descendingMonthComponents: [DateComponents] {
        daysComponentsForMonthComponent.descendingKeys
    }
}

private extension VisitsPreviewList {
    private func visitsPreviewList(isFilled: @escaping () -> Bool) -> some View {
        List {
            ForEach(descendingMonthComponents) { month in
                self.monthYearSideBarWithDayPreviewBlocksView(
                    month: month,
                    daysForMonth: self.descendingDayComponents(for: month),
                    isFilled: isFilled
                )
            }
            .listRowInsets(EdgeInsets())
        }
        .removeAllSeparators()
    }

    private func monthYearSideBarWithDayPreviewBlocksView(month: DateComponents, daysForMonth: [DateComponents], isFilled: @escaping () -> Bool) -> some View {
        H0Stack {
            monthYearSideBarText(date: month.date, shouldAbbreviate: daysForMonth.count == 1)
            V0Stack {
                ForEach(daysForMonth) { day in
                    self.daySideBarWithPreviewBlockView(
                        dayComponent: day,
                        isFilled: isFilled()
                    )
                }
            }
        }
        .frame(height: CGFloat(150*daysForMonth.count))
    }

    private func monthYearSideBarText(date: Date, shouldAbbreviate: Bool) -> MonthYearSideBar {
        MonthYearSideBar(date: date, color: appTheme.color, shouldAbbreviate: shouldAbbreviate)
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

    private func dayPreviewBlockView(dayComponent: DateComponents, isFilled: Bool) -> some View {
        let visits = visitsForDayComponent[dayComponent]!.sortAscByArrivalDate
        return DayPreviewBlock(
            currentDayComponent: $currentDayComponent,
            dayComponent: dayComponent,
            visits: visits,
            isFilled: isFilled,
            onTap: setPreviewInactiveAndHideTheFAB)
            .id(visits)
    }

    private func setPreviewInactiveAndHideTheFAB() {
        isPreviewActive = false
        hideFAB = true
    }
}

private extension VisitsPreviewList {
    private var visitsForActiveDayView: some View {
        VisitsForDayView(
            currentDayComponent: $currentDayComponent,
            visits: visitsForDayComponent[currentDayComponent]?.sortAscByArrivalDate ?? [],
            onBack: setPreviewActiveAndShowTheFAB,
            setActiveVisitLocationAndDisplayMap: setActiveVisitLocationAndDisplayMap,
            setActiveRouteVisitsAndDisplayMap: setActiveRouteVisitsAndDisplayMap
        )
    }

    private func setPreviewActiveAndShowTheFAB() {
        isPreviewActive = true
        hideFAB = false
    }

    private func setActiveVisitLocationAndDisplayMap(visit: Visit) {
        appState.locationControl.currentlyFocused = visit.location
        showMapView()
    }

    private func setActiveRouteVisitsAndDisplayMap(visits: [Visit]) {
        setActiveRouteVisits(visits: visits)
        showMapView()
        hideToggleButton()
    }

    private func setActiveRouteVisits(visits: [Visit]) {
        appState.route.setVisits(visits: visits)
    }

    private func showMapView() {
        appState.showing.homeView = false
    }

    private func hideToggleButton() {
        appState.showing.toggleButton = false
    }
}

struct VisitsPreviewList_Previews: PreviewProvider {
    static var previews: some View {
        VisitsPreviewList(hideFAB: .constant(false), appState: .init())
            .environment(\.managedObjectContext, CoreData.stack.context)
    }
}

