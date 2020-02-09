import SwiftUI

struct VisitsForDayView: View {
    @State private var activeVisitIndex: Int = -1
    @Binding var currentDayComponent: DateComponents
    @Binding var isPreviewActive: Bool
    let visits: [Visit]
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundColor
            
            header
                .padding()
            
            VStack(spacing: 20) {
                dayLabel
                visitsForDayList
            }
            .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 40))
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
    private var backgroundColor: some View {
        ScreenColor(Color("salmon"))
            .saturation(2)
            .animation(.linear)
    }
    
    private var header: some View {
        HStack {
            BImage(perform: setPreviewActive, image: .init(systemName: "arrow.left"))
                .padding(.leading, 20)
            Spacer()
        }
    }
    
    private var dayLabel: some View {
        DayLabel(date: currentDayComponent.date)
            .fade(isVisitActive)
    }
    
    private var visitsForDayList: some View {
        VScroll {
            VStack(spacing: 2) {
                ForEach(visits.indexed(), id: \.1.self) { i, visit in
//                    GeometryReader { geometry in
//                        ZStack {
                            VisitDetailsView(selectedIndex: self.$activeVisitIndex, index: i, visit: visit)
//                                .offset(y: self.isVisitActive.when(true: -geometry.frame(in: .global).minY, false: 0))
//                                .scaleEffect((self.isVisitActive && !self.isActiveVisitIndex(index: i)).when(true: 0.5, false: 1))
//                        }
//                    }
                }
            }
        }
    }
}

struct VisitsForDayView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsForDayView(currentDayComponent: .constant(Date().dateComponents), isPreviewActive: .constant(false), visits: Visit.previewVisitDetails)
    }
}
