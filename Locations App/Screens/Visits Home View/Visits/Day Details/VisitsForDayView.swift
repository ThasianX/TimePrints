import Mapbox
import SwiftUI

fileprivate let listOffset: CGFloat = 95

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
                // Can't do VStack because it interfere with the expand animation so I have to do a ZStack with offset
                .offset(y: isShowingVisit ? 0 : listOffset)
        }
        .background(backgroundColor)
        .animation(.spring())
    }

    private var backgroundColor: some View {
        appTheme.color.saturation(1.5)
            .frame(height: screen.height + 20)
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

fileprivate let listTopPadding: CGFloat = 20

private extension VisitsForDayView {
    private var visitsForDayList: some View {
        VScroll {
            visitsForDayStack
                .frame(width: screen.width)
                .padding(.top, listTopPadding) // A bit of room between the header and list for the row to fold
                // Allows room to scroll up and fold rows. You will also notice that for smaller
                // lists(ones that don't fill up the entire screen height), this padding is
                // crucial because after the offset to the top of the screen,
                // the amount of clickable room is equal to the height of the list.
                // However, by adding the padding, it resolves that issue
                .padding(.bottom, 600)
        }
        .id(currentDayComponent)
    }

    private var visitsForDayStack: some View {
        VStack(spacing: 2) {
            ForEach(0..<visits.count, id: \.self) { i in
                self.dynamicVisitRow(index: i)
                    // Because dynamic visit row is implicitly embedded inside a geometry reader
                    // through `expandableAndFoldable`, we need to explicity define the height and
                    // width of the row so the geometry reader can properly configure itself
                    .frame(height: VisitCellConstants.height)
                    .frame(maxWidth: VisitCellConstants.maxWidth(if: self.isShowingVisit))
            }
        }
    }

    private func dynamicVisitRow(index: Int) -> some View {
        visitDetailsView(index: index, visit: visits[index])
            // After offsetting, you'll notice that if you don't fade the non-expanded rows,
            // the rows after the expanded row will be stacked on top of the expanded row.
            .fade(if: isNotActiveVisit(at: index))
            .expandableAndFoldable(
                rowHeight: VisitCellConstants.height,
                foldOffset: statusBarHeight + listOffset + listTopPadding,
                shouldFold: !isShowingVisit, // do not want to fold if a row is expanded
                isActiveIndex: isVisitIndexActive(at: index)) // used to determine which row should be expanded
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
        isShowingVisit && !isVisitIndexActive(at: index)
    }

    private func isVisitIndexActive(at index: Int) -> Bool {
         index == activeVisitIndex
    }
}

struct VisitsForDayView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsForDayView(currentDayComponent: .constant(Date().dateComponents), visits: Visit.previewVisitDetails, onBack: { },  setActiveVisitLocationAndDisplayMap: { _ in }, setActiveRouteVisitsAndDisplayMap: { _ in })
            .environment(\.appTheme, .violetGum)
    }
}

