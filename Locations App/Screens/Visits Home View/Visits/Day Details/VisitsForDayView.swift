import Mapbox
import SwiftUI

struct VisitsForDayView: View {
    @Environment(\.appTheme) private var appTheme: UIColor

    @State private var activeVisitIndex: Int = -1

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
                .offset(y: !isShowingVisit ? 95 : 0)
        }
        .background(backgroundColor)
        .animation(.spring())
    }

    private var backgroundColor: some View {
        appTheme.color.saturation(1.5)
            .frame(height: screen.height + 50)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
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
                .padding(.top, 20)
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
        visitDetailsView(index: index, visit: visits[index])
            .fade(if: isNotActiveVisit(at: index))
            .expandableAndFoldable(
                foldOffset: 160,
                shouldFold: !isShowingVisit,
                isActiveIndex: isActiveVisitIndex(index: index))
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
}

struct VisitsForDayView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsForDayView(currentDayComponent: .constant(Date().dateComponents), visits: Visit.previewVisitDetails, onBack: { },  setActiveVisitLocationAndDisplayMap: { _ in }, setActiveRouteVisitsAndDisplayMap: { _ in })
            .environment(\.appTheme, .violetGum)
    }
}

