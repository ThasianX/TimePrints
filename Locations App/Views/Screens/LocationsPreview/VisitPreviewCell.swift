//
//  LocationViewCell.swift
//  Locations App
//
//  Created by Kevin Li on 1/30/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct VisitPreviewCell: View {
    let visit: Visit
    
    var body: some View {
        HStack(alignment: .center) {
            Popsicle(tag: visit.tag)

            VStack(alignment: .leading) {
                Text(visit.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text("\(visit.visitDuration)    \(visit.address)")
                    .font(.caption)
                    .lineLimit(1)
            }

            Spacer()
            
            if visit.isFavorite {
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
        VisitPreviewCell(visit: .preview)
    }
}
