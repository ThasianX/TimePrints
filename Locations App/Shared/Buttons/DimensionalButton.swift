// Kevin Li - 12:01 PM - 3/3/20

import SwiftUI

struct DimensionalButton: View {
    @State private var showFirstStroke = false
    @State private var showSecondStroke = false
    @State private var showCheckmark = false

    var circleColor: Color = .pink
    var checkmarkColor: Color = .green
    var radius: CGFloat = 50

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }

    private var firstTurnCircle: some View {
        Circle()
            .strokeBorder(lineWidth: showFirstStroke ? 2 : radius, antialiased: false)
            .frame(width: 100, height: 100)
            .foregroundColor(showFirstStroke ? .green : .pink)
    }
}

private extension DimensionalButton {
    private var checkmarkCircleWidth: CGFloat {
        radius / 25
    }
}

struct DimensionalButton_Previews: PreviewProvider {
    static var previews: some View {
        DimensionalButton()
    }
}
