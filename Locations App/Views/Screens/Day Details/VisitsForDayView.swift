import SwiftUI

struct VisitsForDayView: View {
    @State private var activeVisitIndex: Int = -1
    @Binding var currentDayComponent: DateComponents
    @Binding var isPreviewActive: Bool
    let visits: [Visit]
    
    var body: some View {
        ZStack(alignment: .top) {
            header
                .frame(width: screen.bounds.width)
            
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
    
    private var isVisitActive: Bool {
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
            .fade(isVisitActive)
    }
    
    private var visitsForDayList: some View {
        VScroll {
            VStack(spacing: 2) {
                ForEach(self.visits.indexed(), id: \.1.self) { i, visit in
                    GeometryReader { geometry in
                        ZStack {
                            VisitDetailsView(selectedIndex: self.$activeVisitIndex, index: i, visit: visit)
                                .offset(y: self.isVisitActive.when(true: -geometry.frame(in: .global).minY, false: 0))
                                .scaleEffect((self.isVisitActive && !self.isActiveVisitIndex(index: i)).when(true: 0.5, false: 1))
                        }
                    }
                    .frame(height: 100)
                }
            }
            .frame(width: screen.bounds.width)
        }
    }
}

struct VisitsForDayView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsForDayView(currentDayComponent: .constant(Date().dateComponents), isPreviewActive: .constant(false), visits: Visit.previewVisitDetails)
    }
}
