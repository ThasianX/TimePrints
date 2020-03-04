import SwiftUI

struct ColorAdaptiveVisitsView: View {
    let color: Color

    var body: some View {
        var fill = false

        func isFilled() -> Bool {
            fill.toggle()
            return fill
        }

        return ZStack {
            VScroll {
                V0Stack {
                    leftAlignedHeader
                    monthYearSideBarWithColorAdaptiveBlockView(isFilled: isFilled)
                        .extendToScreenEdges()
                }
                .frame(width: screen.width)
            }
        }
    }
}

private extension ColorAdaptiveVisitsView {
    private var leftAlignedHeader: some View {
        HStack {
            headerText
            Spacer()
        }
        .padding()
    }

    private var headerText: some View {
        Text("Visits")
            .font(.largeTitle)
            .foregroundColor(color)
    }
}

private extension ColorAdaptiveVisitsView {
    private func monthYearSideBarWithColorAdaptiveBlockView(isFilled: @escaping () -> Bool) -> some View {
        HStack {
            self.monthYearSideBarText(date: Date())
            self.visitsPreviewStack(isFilled: isFilled)
        }
    }

    private func monthYearSideBarText(date: Date) -> some View {
        MonthYearSideBar(date: date, color: color)
    }

    private func visitsPreviewStack(isFilled: @escaping () -> Bool) -> some View {
        V0Stack {
            self.colorAdaptiveBlockView(roundedCorners: [.topLeft], isFilled: isFilled())
            ForEach(0..<5, id: \.self) { _ in
                self.colorAdaptiveBlockView(roundedCorners: [], isFilled: isFilled())
            }
        }
    }

    private func colorAdaptiveBlockView(roundedCorners: UIRectCorner, isFilled: Bool) -> some View {
        Rectangle()
            .fill(color)
            .saturation(isFilled ? 1.5 : 1)
            .frame(height: 150)
            .cornerRadius(20, corners: roundedCorners)
    }
}

struct ColorAdaptiveVisitsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorAdaptiveVisitsView(color: .red)
    }
}
