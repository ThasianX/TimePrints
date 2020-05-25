import Mapbox
import SwiftUI

struct VisitsForDayView: View {
    @State private var activeVisitIndex: Int = -1
    @State var activeTranslation = CGSize.zero

    @Binding var currentDayComponent: DateComponents

    let visits: [Visit]
    let onBack: () -> Void
    let setActiveVisitLocationAndDisplayMap: (Visit) -> Void
    let setActiveRouteVisitsAndDisplayMap: ([Visit]) -> Void

    private var isShowingVisit: Bool {
        activeVisitIndex != -1
    }

    var body: some View {
        ZStack(alignment: .top) {
            header
            visitsForDayList
                .offset(y: !isShowingVisit ? 110 : 0)
        }
    }
}

private extension VisitsForDayView {
    private var header: some View {
        ZStack {
            HStack {
                backButton
                Spacer()
                routeButton
            }
            dayLabel
        }
        .padding(30)
    }

    private var backButton: some View {
        BImage(perform: onBack, image: Image(systemName: "arrow.left"))
    }

    private var dayLabel: some View {
        DayLabel(date: currentDayComponent.date)
    }

    private var routeButton: some View {
        Button(action: _setActiveRouteVisitsAndDisplayMap) {
            Image("route")
                .renderingMode(.template)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func _setActiveRouteVisitsAndDisplayMap() {
        setActiveRouteVisitsAndDisplayMap(visits)
    }
}

private extension VisitsForDayView {
    private var visitsForDayList: some View {
        VScroll {
            visitsForDayStack
                .frame(width: screen.width)
                .padding(.bottom, 600)
        }
    }

    private var visitsForDayStack: some View {
        VStack(spacing: 2) {
            ForEach(0..<visits.count, id: \.self) { i in
                self.dynamicVisitRow(index: i)
                    .frame(height: VisitCellConstants.height)
                    .frame(maxWidth: VisitCellConstants.maxWidth(if: self.isShowingVisit))
            }
        }
    }

    private func dynamicVisitRow(index: Int) -> some View {
        GeometryReader { geometry in
            self.visitDetailsView(index: index, visit: self.visits[index])
                .fade(if: self.isNotActiveVisit(at: index))
                .offset(y: self.isActiveVisitIndex(index: index) ? self.topOfScreen(for: geometry) : 0)
                .rotation3DEffect(self.rotationAngle(for: geometry), axis: (x: -200, y: 0, z: 0), anchor: .bottom)
                .opacity(self.opacity(for: geometry))
        }
    }

    private func visitDetailsView(index: Int, visit: Visit) -> some View {
        VisitDetailsView(
            selectedIndex: $activeVisitIndex,
            index: index,
            visit: visit,
            setActiveVisitLocationAndDisplayMap: setActiveVisitLocationAndDisplayMap
        )
        .id(visit.tagName)
        .id(visit.tagColor)
    }

    private func isNotActiveVisit(at index: Int) -> Bool {
        isShowingVisit && !isActiveVisitIndex(index: index)
    }

    private func isActiveVisitIndex(index: Int) -> Bool {
        index == activeVisitIndex
    }

    private func topOfScreen(for proxy: GeometryProxy) -> CGFloat {
        -proxy.frame(in: .global).minY
    }

    private func rotationAngle(for proxy: GeometryProxy) -> Angle {
        guard !isShowingVisit else { return .degrees(0) }
        let minY = proxy.frame(in: .global).minY
        return .degrees(minY < 150 ? -foldDegree(for: minY) : 0)
    }

    private func foldDegree(for minY: CGFloat) -> Double {
        let delta = foldDelta(for: minY)
        guard delta >= 0 else { return 90 }
        return 90 - (90 * delta)
    }

    private func opacity(for proxy: GeometryProxy) -> Double {
        guard !isShowingVisit else { return 1 }
        let minY = proxy.frame(in: .global).minY
        return minY < 150 ? foldDelta(for: minY) + 0.4 : 1
    }

    private func foldDelta(for minY: CGFloat) -> Double {
        Double((VisitCellConstants.height + (minY - 150)) / VisitCellConstants.height)
    }
}

struct VisitsForDayView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsForDayView(currentDayComponent: .constant(Date().dateComponents), visits: Visit.previewVisitDetails, onBack: { },  setActiveVisitLocationAndDisplayMap: { _ in }, setActiveRouteVisitsAndDisplayMap: { _ in })
            .environment(\.appTheme, .violetGum)
    }
}

