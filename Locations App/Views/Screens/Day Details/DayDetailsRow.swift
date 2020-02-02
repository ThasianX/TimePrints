//
//  LocationDetailsRow.swift
//  Locations App
//
//  Created by Kevin Li on 2/1/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct DayDetailsRow: View {
    @State private var mapFull = false
    @Binding var selectedIndex: Int
    let id: Int
    let location: Location
    let color: Color
    
    var body: some View {
        ZStack(alignment: .top) {
            if isSelected {
                SuperColor(color).saturation(2)
                
                header
                    .padding(.init(top: 5, leading: 30, bottom: 0, trailing: 30))
                    .offset(y: 60)
                    .opacity(mapFull ? 0 : 1)
            }
            
            VStack {
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
                    
                    VSpace(isSelected ? 20 : 12)
                    Popsicle(tag: location.tag, displayName: isSelected)
                        .rotated(.init(degrees: isSelected ? 0 : 90))
                    VSpace(isSelected ? 20 : 12)
                }
                .opacity(mapFull ? 0 : 1)
                
                if isSelected {
                    map
                }
                
                Text(location.notes)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(isSelected ? nil : 3)
                    .opacity(mapFull ? 0 : 1)
            }
            .padding(.init(top: 20, leading: 40, bottom: 20, trailing: 40))
            .offset(y: isSelected ? 40 : 0)
            .offset(y: mapFull ? -80 : 0)
            .roundedFill(with: isSelected ? .clear : color)
        }
//        .frame(width: isSelected ? screen.bounds.width : nil, height: isSelected ? screen.bounds.height : nil)
    }
}

// MARK: - Computed Properties and Helper Functions
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

    
    private func unselectRow() {
        self.selectedIndex = -1
    }
    
    private func favorite() {
        location.favorite()
    }
}

// MARK: - Content
extension DayDetailsRow {
    var header: some View {
        HStack {
            BImage(action: unselectRow, image: .init(systemName: "arrow.left"))
            Spacer()
            BImage(action: favorite, image: location.isFavorite ? .init(systemName: "star.fill") : .init(systemName: "star"))
                .foregroundColor(.yellow)
        }
    }
    
    var map: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 20) {
                StaticMapView(coordinate: location.coordinate)
                    .frame(width: mapFull ? screen.bounds.width : screen.bounds.width / 2.5, height: mapFull ? screen.bounds.height * 3 / 4 : screen.bounds.width / 2.5)
                    .cornerRadius(mapFull ? 0 : screen.bounds.width / 5)
                    .onTapGesture {
                        withAnimation {
                            self.mapFull.toggle()
                        }
                    }
                    .animation(.spring())
                Text(location.address.uppercased())
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 60, height: 3)
                    .opacity(mapFull ? 0 : 1)
                notes
                    .opacity(mapFull ? 0 : 1)
            }

            BImage(condition: $mapFull, image: .init(systemName: "arrow.left.circle.fill"))
                .scaleEffect(2.5)
                .opacity(mapFull ? 1 : 0)
                .allowsHitTesting(mapFull)
                .offset(x: 40, y: screen.bounds.height / 15)
                .animation(nil)
                .transition(.identity)
        }
    }
    
    var notes: some View {
        VStack(spacing: 2) {
            Text("NOTES")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .tracking(2)
            if location.notes.isEmpty {
                Text("TAP TO ADD")
                    .font(.caption)
            }
        }
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
