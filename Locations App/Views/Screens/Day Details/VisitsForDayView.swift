import SwiftUI

struct VisitsForDayView: View {
    @State private var activeVisitIndex: Int = -1
    @Binding var currentDayComponent: DateComponents
    @Binding var isPreviewActive: Bool
    let visits: [Visit]
    
    var body: some View {
        ZStack(alignment: .top) {
            header
            visitsForDayList
                .offset(y: isShowingVisit.when(true: 0, false: 100))
        }
    }
}

private extension VisitsForDayView {
    private func setPreviewActive() {
        isPreviewActive = true
    }
    
    private var isShowingVisit: Bool {
        activeVisitIndex != -1
    }
    
    private func isActiveVisitIndex(index: Int) -> Bool {
        index == activeVisitIndex
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
        BImage(perform: setPreviewActive, image: .init(systemName: "arrow.left"))
    }
    
    private var dayLabel: some View {
        DayLabel(date: currentDayComponent.date)
    }
    
    private var visitsForDayList: some View {
        VScroll {
            VStack(spacing: 2) {
                ForEach(self.visits.indexed(), id: \.1.self) { i, visit in
                    GeometryReader { geometry in
                        ZStack {
                            VisitDetailsView(selectedIndex: self.$activeVisitIndex, index: i, visit: visit)
                                .scaleEffect((self.isShowingVisit && !self.isActiveVisitIndex(index: i)).when(true: 0.5, false: 1))
                                .offset(y: self.isShowingVisit.when(true: -geometry.frame(in: .global).minY, false: 0))
                                .fade(self.isShowingVisit && !self.isActiveVisitIndex(index: i))
                        }
                    }
                    .frame(height: VisitCellConstants.height)
                    .frame(maxWidth: VisitCellConstants.maxWidth(if: self.isShowingVisit))
                }
            }
            .frame(width: screen.width)
            .padding(.bottom, 300)
            .animation(.spring())
        }
    }
}

struct VisitsForDayView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsForDayView(currentDayComponent: .constant(Date().dateComponents), isPreviewActive: .constant(false), visits: Visit.previewVisitDetails)
    }
}
