import SwiftUI

struct VisitsForDayView: View {
    @State private var activeVisitIndex: Int = -1
    @State var activeTranslation = CGSize.zero

    @Binding var currentDayComponent: DateComponents
    @Binding var isPreviewActive: Bool

    let visits: [Visit]
    let setActiveVisitLocationAndDisplayMap: (Visit) -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            header
            visitsForDayList
                .offset(y: isShowingVisit.when(true: 0, false: 100))
        }
        .simultaneousGesture(exitGesture)
        .scaleEffect(1 - self.activeTranslation.width/1000)
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
                            VisitDetailsView(
                                selectedIndex: self.$activeVisitIndex,
                                index: i,
                                visit: visit,
                                setActiveVisitLocationAndDisplayMap: self.setActiveVisitLocationAndDisplayMap)
                                .scaleEffect((self.isShowingVisit && !self.isActiveVisitIndex(index: i)) ? 0.5 : 1)
                                .offset(y: self.isShowingVisit ? -geometry.frame(in: .global).minY : 0)
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

private extension VisitsForDayView {
    private var exitGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard value.translation.width < 100 else { return }

                self.activeTranslation = value.translation
        }
        .onEnded { value in
            if self.activeTranslation.width > 30 {
                self.setPreviewActive()
            }
            self.resetActiveTranslation()
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

    private func resetActiveTranslation() {
        activeTranslation = .zero
    }
}


struct VisitsForDayView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsForDayView(currentDayComponent: .constant(Date().dateComponents), isPreviewActive: .constant(false), visits: Visit.previewVisitDetails, setActiveVisitLocationAndDisplayMap: { _ in })
    }
}
