//
//  LocationViewCell.swift
//  Locations App
//
//  Created by Kevin Li on 1/30/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct LocationPreviewCell: View {
    let location: Location
    
    var body: some View {
        HStack(alignment: .center) {
            Rectangle()
                .fill(Color(location.tag.color))
                .cornerRadius(20)
                .frame(width: 5, height: 40)

            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text("\(location.arrivalDate.timeOnlyWithPadding) ⟶ \(location.departureDate.timeOnlyWithPadding)    \(location.address)")
                    .font(.caption)
                    .lineLimit(1)
            }

            Spacer()
            
            if location.isFavorite {
                Image(systemName: "star.fill")
                    .imageScale(.medium)
                    .foregroundColor(.yellow)
            }
        }
        .frame(height: 50)
        .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
    
}

struct LocationPreviewCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationPreviewCell(location: .preview)
    }
}
