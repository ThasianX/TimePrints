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

//
//struct LocationViewCell: View {
////    let location: Location
//
//    var body: some View {
//        HStack {
//            Rectangle()
//                .fill(Color.black)
//                .cornerRadius(20)
//                .frame(width: 5, height: 40)
//                .padding(.init(top: 10, leading: 0, bottom: 6, trailing: 0))
//
//            VStack(alignment: .leading) {
//                Text("Apple Inc")
//                    .font(.title)
//                    .lineLimit(1)
//                Text("12:00 AM ⟶ 11:15 AM   Hitchcock hall 180")
//                    .font(.caption)
//                    .lineLimit(1)
//            }
//
//            Spacer()
//
//            if true {
//                Image(systemName: "star.fill")
//                    .imageScale(.medium)
//                    .foregroundColor(.yellow)
//            }
//        }
//        .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
//    }
//
//}
//
//struct LocationViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            LocationViewCell()
//                .border(Color.black)
//        }
//    }
//}
