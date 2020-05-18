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
    private var overlayColor: some View {
        ScreenColor(appTheme.color)
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
            ForEach(descendingMonthComponents) { month in
                self.monthYearSideBarWithDayPreviewBlocksView(
                    month: month,
                    daysForMonth: self.descendingDayComponents(for: month),
                    isFilled: isFilled
                )
            }
        }
    }

    private func monthYearSideBarWithDayPreviewBlocksView(month: DateComponents, daysForMonth: [DateComponents], isFilled: @escaping () -> Bool) -> some View {
        H0Stack {
            monthYearSideBarText(date: month.date)
            V0Stack {
                ForEach(daysForMonth) { day in
                    self.daySideBarWithPreviewBlockView(
                        dayComponent: day,
                        roundedCorners: self.roundedCorners(for: month, daysForMonth: daysForMonth, day: day),
                        isFilled: isFilled()
                    )
                }
            }
        }
    }

    private func monthYearSideBarText(date: Date) -> MonthYearSideBar {
        MonthYearSideBar(date: date, color: appTheme.color)
    }

    private func descendingDayComponents(for monthComponent: DateComponents) -> [DateComponents] {
        daysComponentsForMonthComponent[monthComponent]!.sortDescending
    }

    private func daySideBarWithPreviewBlockView(dayComponent: DateComponents, roundedCorners: UIRectCorner, isFilled: Bool) -> some View {
        HStack {
            daySideBarView(date: dayComponent.date)
            dayPreviewBlockView(dayComponent: dayComponent, roundedCorners: roundedCorners, isFilled: isFilled)
        }
        .frame(height: 150)
    }

    private func daySideBarView(date: Date) -> DaySideBar {
        DaySideBar(date: date)
    }

    private func dayPreviewBlockView(dayComponent: DateComponents, roundedCorners: UIRectCorner, isFilled: Bool) -> DayPreviewBlock {
        DayPreviewBlock(
            currentDayComponent: $currentDayComponent,
            visits: visitsForDayComponent[dayComponent]!.sortAscByArrivalDate,
            roundedCorners: roundedCorners,
            isFilled: isFilled,
            dayComponent: dayComponent,
            onTap: setPreviewInactive
        )
    }

    private func setPreviewInactive() {
        isPreviewActive = false
        hideFAB = true
    }

    private func roundedCorners(for month: DateComponents, daysForMonth: [DateComponents], day: DateComponents) -> UIRectCorner {
        var roundedCorners: UIRectCorner = []
        if isFirstVisit(month: month, daysForMonth: daysForMonth, day: day) {
            roundedCorners.insert(.topLeft)
        }
        if isLastVisit(month: month, daysForMonth: daysForMonth, day: day) {
            roundedCorners.insert(.bottomLeft)
        }
        return roundedCorners
    }

    private func isFirstVisit(month: DateComponents, daysForMonth: [DateComponents], day: DateComponents) -> Bool {
        month == descendingMonthComponents.first! && day == daysForMonth.first!
    }

    private func isLastVisit(month: DateComponents, daysForMonth: [DateComponents], day: DateComponents) -> Bool {
        month == descendingMonthComponents.last! && day == daysForMonth.last!
    }
}

private extension VisitsPreviewList {
    private var visitsForActiveDayView: some View {
        VisitsForDayView(
            currentDayComponent: $currentDayComponent,
            visits: visitsForDayComponent[currentDayComponent]?.sortAscByArrivalDate ?? [],
            onBack: setPreviewActive,
            setActiveVisitLocationAndDisplayMap: setActiveVisitLocationAndDisplayMap,
            setActiveRouteVisitsAndDisplayMap: setActiveRouteVisitsAndDisplayMap
        )
    }

    private func setPreviewActive() {
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
            .statusBar(hidden: true)
    }
}

