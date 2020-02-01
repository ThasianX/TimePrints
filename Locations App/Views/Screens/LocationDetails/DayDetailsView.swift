//
//  DayDetailsView.swift
//  Locations App
//
//  Created by Kevin Li on 2/1/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct DayDetailsView: View {
    @Binding var show: Bool
    let date: Date
    let locations: [Location]
    
    var body: some View {
        ZStack(alignment: .top) {
            SuperColor(Color.green)
            VStack(spacing: 2) {
                HStack {
                    BImage(condition: $show, image: .init(systemName: "arrow.left"))
                    Spacer()
                    DayLabel(date: date)
                    Spacer()
                }
                .padding()
                
                ForEach(locations) { location in
                    LocationDetailsRow(location: location, color: .blue)
                }
            }
            .padding()
        }
    }
}

struct DayDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DayDetailsView(show: .constant(true), date: Date(), locations: Location.previewLocationDetails)
    }
}
