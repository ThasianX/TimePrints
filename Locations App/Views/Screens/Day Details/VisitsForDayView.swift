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
                .offset(y: 100)
        }
    }
}

// MARK: Helpers
private extension VisitsForDayView {
    private func setPreviewActive() {
        isPreviewActive = true
    }
    
    private var isShowing: Bool {
        activeVisitIndex != -1
    }
    
    private func isActiveVisitIndex(index: Int) -> Bool {
        index == activeVisitIndex
    }
}

// MARK: Content
private extension VisitsForDayView {
    private var header: some View {
        HStack {
            backButton
            Spacer()
            dayLabel
            Spacer()
        }
        .padding()
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
                                .offset(y: self.isShowing.when(true: -geometry.frame(in: .global).minY, false: 0))
                                .scaleEffect((self.isShowing && !self.isActiveVisitIndex(index: i)).when(true: 0.5, false: 1))
                        }
                    }
                    .frame(height: 100)
                }
            }
            .frame(width: screen.width)
            .padding(.bottom, 300)
            .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0))
        }
    }
}

struct VisitsForDayView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsForDayView(currentDayComponent: .constant(Date().dateComponents), isPreviewActive: .constant(false), visits: Visit.previewVisitDetails)
    }
}
