import SwiftUI

struct DayPreviewBlock: View {
    @Environment(\.appTheme) private var appTheme: UIColor
    
    @State private var visitIndex = 0
    @State private var timer: Timer?

    @Binding var currentDayComponent: DateComponents

    let visits: [Visit]
    let isFilled: Bool
    let dayComponent: DateComponents
    let onTap: () -> Void
    
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
    private var backgroundColor: some View {
        appTheme.color
            .saturation(isFilled ? 1.5 : 1)
    }

    private var visitsPreviewList: some View {
        V0Stack {
            ForEach(visits[range]) { visit in
                VisitPreviewCell(visit: visit)
            }
        }
    }
}

private extension DayPreviewBlock {
    private func setTimerForVisitsSlideshow() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.onTimerFire()
        }
    }

    private func onTimerFire() {
        withAnimation {
            shiftActivePreviewVisitIndex()
        }
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
    private func setCurrentDayComponentAndPreviewInactive() {
        onTap()
        setCurrentDayComponent()
    }

    private func setCurrentDayComponent() {
        currentDayComponent = dayComponent
    }
}

struct DayPreviewBlock_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayPreviewBlock(currentDayComponent: .constant(DateComponents()), visits: [], isFilled: false, dayComponent: DateComponents(), onTap: { })
                .environment(\.appTheme, .violetGum)
        }
    }
}
