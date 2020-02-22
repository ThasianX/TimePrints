import SwiftUI

struct VisitsForDayView: View {
    @State private var activeVisitIndex: Int = -1
    @State var activeTranslation = CGSize.zero

    @Binding var currentDayComponent: DateComponents
    @Binding var isPreviewActive: Bool

    let visits: [Visit]
    let setActiveVisitLocationAndDisplayMap: (Visit) -> Void

    private var isShowingVisit: Bool {
        activeVisitIndex != -1
    }

    var body: some View {
        ZStack(alignment: .top) {
            header
            visitsForDayList
                .offset(y: !isShowingVisit ? 100 : 0)
        }
    }
}

private extension VisitsForDayView {
    private var header: some View {
        ZStack {
            HStack {
                backButton
                Spacer()
            }
            dayLabel
        }
        .padding(30)
    }

    private var backButton: some View {
        BImage(perform: setPreviewActive, image: Image(systemName: "arrow.left"))
    }

    private func setPreviewActive() {
        isPreviewActive = true
    }

    private var dayLabel: some View {
        DayLabel(date: currentDayComponent.date)
    }

    private var visitsForDayList: some View {
        VScroll {
            makeVisitsStack
                .frame(width: screen.width)
                .padding(.bottom, 600)
                .animation(.spring())
        }
    }

    private var makeVisitsStack: some View {
        VStack(spacing: 2) {
            ForEach(0..<visits.count, id: \.self) { i in
                self.dynamicVisitRow(index: i, visit: self.visits[i])
                    .frame(height: VisitCellConstants.height)
                    .frame(maxWidth: VisitCellConstants.maxWidth(if: self.isShowingVisit))
            }
        }
    }

    private func dynamicVisitRow(index: Int, visit: Visit) -> some View {
        GeometryReader { geometry in
            self.makeVisitDetailsView(index: index, visit: visit)
                .fade(if: self.isShowingVisit && !self.isActiveVisitIndex(index: index))
                .scaleEffect((self.isShowingVisit && !self.isActiveVisitIndex(index: index)) ? 0.5 : 1)
                .offset(y: self.isShowingVisit ? -geometry.frame(in: .global).minY : 0)
        }
    }

    private func makeVisitDetailsView(index: Int, visit: Visit) -> some View {
        VisitDetailsView(
            selectedIndex: $activeVisitIndex,
            index: index,
            visit: visit,
            setActiveVisitLocationAndDisplayMap: setActiveVisitLocationAndDisplayMap
        )
        .id(visit.tagName)
        .id(visit.tagColor)
    }

    private func isActiveVisitIndex(index: Int) -> Bool {
        index == activeVisitIndex
    }
}

struct VisitsForDayView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsForDayView(currentDayComponent: .constant(Date().dateComponents), isPreviewActive: .constant(false), visits: Visit.previewVisitDetails, setActiveVisitLocationAndDisplayMap: { _ in })
    }
}

