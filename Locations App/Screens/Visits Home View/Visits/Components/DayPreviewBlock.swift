import SwiftUI

struct DayPreviewBlock: View {
    @Environment(\.appTheme) private var appTheme: UIColor

    private let timer = Timer.publish(every: VisitPreviewConstants.previewTime,
                                      on: .main, in: .common).autoconnect()
    @State var visitIndex = 0

    @Binding var currentDayComponent: DateComponents

    let dayComponent: DateComponents
    let visits: [Visit]
    let isFilled: Bool
    let onTap: () -> Void
    
    private var range: Range<Int> {
        let exclusiveEndIndex = visitIndex + VisitPreviewConstants.numberOfCellsInBlock
        guard visits.count > VisitPreviewConstants.numberOfCellsInBlock &&
            exclusiveEndIndex <= visits.count else {
            return visitIndex..<visits.count
        }
        return visitIndex..<exclusiveEndIndex
    }
    
    var body: some View {
        ZStack {
            backgroundColor
            visitsPreviewList
                .animation(.easeInOut)
        }
        .onTapGesture(perform: setCurrentDayComponentAndPreviewInactive)
        .onAppear(perform: setUpVisitsSlideShow)
        .onReceive(timer) { _ in
            self.shiftActivePreviewVisitIndex()
        }
    }

    private func setUpVisitsSlideShow() {
        if visits.count <= VisitPreviewConstants.numberOfCellsInBlock {
            // To reduce memory usage, we don't want the timer to fire when
            // visits count is less than or equal to the number
            // of visits allowed in a single slide
            timer.upstream.connect().cancel()
        }
    }

    private func shiftActivePreviewVisitIndex() {
        let startingVisitIndexOfNextSlide = visitIndex + VisitPreviewConstants.numberOfCellsInBlock
        let startingVisitIndexOfNextSlideIsValid = startingVisitIndexOfNextSlide < visits.count
        visitIndex = startingVisitIndexOfNextSlideIsValid ? startingVisitIndexOfNextSlide : 0
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
                    .id(visit.location.tag.color)
                    .id(visit.location.name)
                    .id(visit.isFavorite)
            }
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
            DayPreviewBlock(currentDayComponent: .constant(DateComponents()), dayComponent: DateComponents(), visits: [], isFilled: false, onTap: { })
                .environment(\.appTheme, .violetGum)
        }
    }
}
