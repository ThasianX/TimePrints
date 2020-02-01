//
//  LocationDetailsRow.swift
//  Locations App
//
//  Created by Kevin Li on 2/1/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct LocationDetailsRow: View {
    let location: Location
    let color: Color
    
    var body: some View {
        VStack {
            Text(location.name)
                .font(.headline)
            Text(location.visitDuration)
                .font(.caption)
            Popsicle(color: location.accent)
                .rotated(.init(degrees: 90))
            Text(location.notes)
                .font(.caption)
                .lineLimit(3)
        }
        .padding(.init(top: 10, leading: 50, bottom: 10, trailing: 50))
        .background(RoundedRectangle(cornerRadius: 8).stroke(color).background(color).cornerRadius(16))
    }
}

struct LocationDetailsRow_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailsRow(location: .preview, color: .blue)
    }
}
