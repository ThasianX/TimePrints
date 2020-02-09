import SwiftUI

struct VisitsForDayView: View {
    @State private var selectedIndex: Int = -1
    @Binding var currentDayComponent: DateComponents
    let visits: [Visit]
    
    private var showingDetail: Bool {
        selectedIndex != -1
    }
    
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
    private func resetCurrentDayComponent() {
        currentDayComponent = DateComponents()
    }
    
    private func setSelectedVisitIndex(index: Int) {
        withAnimation {
            self.selectedIndex = index
        }
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
            BImage(perform: resetCurrentDayComponent, image: .init(systemName: "arrow.left"))
                .padding(.leading, 20)
            Spacer()
        }
    }
    
    private var dayLabel: some View {
        DayLabel(date: currentDayComponent.date)
            .fade(showingDetail)
    }
    
    private var visitsForDayList: some View {
        VScroll {
            VStack(spacing: 2) {
                ForEach(visits.indexed(), id: \.1.self) { i, visit in
                    DayDetailsRow(selectedIndex: self.$selectedIndex, id: i, visit: visit)
                        .onTapGesture { self.setSelectedVisitIndex(index: i) }
                }
            }
        }
        .fade(showingDetail)
    }
}

struct VisitsForDayView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsForDayView(currentDayComponent: .constant(Date().dateComponents), visits: Visit.previewVisitDetails)
    }
}
