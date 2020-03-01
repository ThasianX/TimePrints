import SwiftUI

struct DayPreviewBlock: View {
    @State private var visitIndex = 0
    @State private var timer: Timer?

    @Binding var currentDayComponent: DateComponents
    @Binding var isPreviewActive: Bool
    @Binding var hideFAB: Bool

    let visits: [Visit]
    let isFilled: Bool
    let dayComponent: DateComponents
    
    private var range: Range<Int> {
        return visitIndex ..< ((visitIndex + 3 > visits.count) ? visits.count : visitIndex + 3)
    }
    
    var body: some View {
        ZStack {
            backgroundColor
            visitsPreviewList
                .animation(.easeInOut)
        }
        .onAppear(perform: setTimerForVisitsSlideshow)
        .onTapGesture(perform: setCurrentDayComponentAndPreviewInactive)
    }
}

private extension DayPreviewBlock {
    private func setCurrentDayComponentAndPreviewInactive() {
        setPreviewInactive()
        setCurrentDayComponent()
    }
    
    private func setCurrentDayComponent() {
        currentDayComponent = dayComponent
    }
    
    private func setPreviewInactive() {
        isPreviewActive = false
        hideFAB = true
    }
}

private extension DayPreviewBlock {
    private func setTimerForVisitsSlideshow() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            withAnimation {
                self.onTimerFire()
            }
        }
    }

    private func onTimerFire() {
        shiftActivePreviewVisitIndex()
    }

    private func shiftActivePreviewVisitIndex() {
        let visitIndexExists = self.visitIndex < self.visits.count-3
        if visitIndexExists {
            self.visitIndex += 3
        } else {
            self.visitIndex = 0
        }
    }
}

private extension DayPreviewBlock {
    private var backgroundColor: some View {
        Color("salmon")
            .saturation(isFilled ? 2 : 1)
    }
    
    private var visitsPreviewList: some View {
        V0Stack {
            ForEach(visits[range]) { visit in
                VisitPreviewCell(visit: visit)
            }
        }
    }
}

struct DayPreviewBlock_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayPreviewBlock(currentDayComponent: .constant(DateComponents()), isPreviewActive: .constant(true), hideFAB: .constant(true), visits: [], isFilled: false, dayComponent: DateComponents())
        }
    }
}
