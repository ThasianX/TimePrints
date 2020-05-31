import SwiftUI

struct MonthYearSideBar: View {
    let date: Date
    let color: Color
    let shouldAbbreviate: Bool
    
    var body: some View {
        monthYearText
    }
}

private extension MonthYearSideBar {
    var monthYearText: some View {
        Text(monthYearString)
            .tracking(10)
            .foregroundColor(color)
            .font(.caption)
            .fontWeight(.semibold)
            .rotated(.degrees(-90))
            .padding()
    }

    var monthYearString: String {
        shouldAbbreviate ? date.abbreviatedMonthWithYear : date.fullMonthWithYear
    }
}

struct MonthSideBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.extendToScreenEdges()
            MonthYearSideBar(date: Date(), color: .red, shouldAbbreviate: false)
        }
    }
}
