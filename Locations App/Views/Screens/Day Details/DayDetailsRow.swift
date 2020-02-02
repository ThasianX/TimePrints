//
//  LocationDetailsRow.swift
//  Locations App
//
//  Created by Kevin Li on 2/1/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct DayDetailsRow: View {
    @Binding var selectedIndex: Int
    let id: Int
    let location: Location
    let color: Color
    
    var body: some View {
        ZStack(alignment: .top) {
            if isSelected {
                SuperColor(color).saturation(2)
                
                HStack {
                    BImage(action: unselectRow, image: .init(systemName: "arrow.left"))
                    Spacer()
                    BImage(action: favorite, image: location.isFavorite ? .init(systemName: "star.fill") : .init(systemName: "star"))
                        .foregroundColor(.yellow)
                }
                .padding(.init(top: 5, leading: 30, bottom: 0, trailing: 30))
                .offset(y: 60)
            }
            
            VStack {
                Text(location.name)
                    .font(nameFont)
                    .fontWeight(nameWeight)
                
                VSpace(isSelected ? 20 : 0)
                
                Text(location.visitDuration)
                    .font(visitDurationFont)
                
                if isSelected {
                    Text(location.arrivalDate.fullMonthWithDayOfWeek.uppercased()).font(.caption)
                }
                
                VSpace(isSelected ? 20 : 4)
                
                Popsicle(tag: location.tag, displayName: isSelected)
                    .rotated(.init(degrees: isSelected ? 0 : 90))
                
                VSpace(isSelected ? 20 : 4)
                
                Text(location.notes)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(isSelected ? nil : 3)
                
                if isSelected {
                    Spacer()
                }
            }
            .padding(.init(top: 20, leading: 40, bottom: 20, trailing: 40))
            .offset(y: isSelected ? 40 : 0)
            .roundedFill(with: isSelected ? .clear : color)
        }
        .frame(width: isSelected ? screen.bounds.width : nil, height: isSelected ? screen.bounds.height : nil)
    }
    
    private func unselectRow() {
        self.selectedIndex = -1
    }
    
    private func favorite() {
        location.favorite()
    }
}

extension DayDetailsRow {
    private var isSelected: Bool {
        selectedIndex == id
    }
    
    private var nameFont: Font {
        isSelected ? .system(size: 22) : .headline
    }
    
    private var nameWeight: Font.Weight {
        isSelected ? .bold : .regular
    }
    
    private var visitDurationFont: Font {
        isSelected ? .system(size: 18) : .system(size: 10)
    }
}

struct DayDetailsRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayDetailsRow(selectedIndex: .constant(1), id: -1, location: .preview, color: Color("salmon")).previewLayout(.sizeThatFits)
            
            DayDetailsRow(selectedIndex: .constant(1), id: 1, location: .preview, color: Color("salmon"))
        }
        
    }
}
