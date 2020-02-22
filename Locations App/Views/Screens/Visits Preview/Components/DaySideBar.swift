import SwiftUI

struct DaySideBar: View {
    let date: Date
    
    var body: some View {
        VStack {
            abbreviatedDayOfWeek
            dayOfMonth
        }
        .frame(width: 35)
    }
}

private extension DaySideBar {
    private var abbreviatedDayOfWeek: some View {
        Text(date.abbreviatedDayOfWeek.uppercased())
            .font(.caption)
            .foregroundColor(.gray)
    }
    
    private var dayOfMonth: some View {
        Text(date.dayOfMonth)
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
}

struct DaySideBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.extendToScreenEdges()
            DaySideBar(date: Date())
        }
    }
}
