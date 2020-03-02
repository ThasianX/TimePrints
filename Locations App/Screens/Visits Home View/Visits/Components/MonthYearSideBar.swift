import SwiftUI

struct MonthYearSideBar: View {
    let date: Date
    let color: Color
    
    var body: some View {
        fullMonthWithYear
    }
}

private extension MonthYearSideBar {
    private var fullMonthWithYear: some View {
        Text(date.fullMonthWithYear)
            .tracking(10)
            .foregroundColor(color)
            .font(.caption)
            .fontWeight(.semibold)
            .rotated(.degrees(-90))
            .padding()
    }
}

struct MonthSideBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.extendToScreenEdges()
            MonthYearSideBar(date: Date(), color: .red)
        }
    }
}
