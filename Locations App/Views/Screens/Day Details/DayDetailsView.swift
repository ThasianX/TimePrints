//
//  DayDetailsView.swift
//  Locations App
//
//  Created by Kevin Li on 2/1/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct DayDetailsView: View {
    @State private var selectedIndex: Int = -1
    @Binding var show: Bool
    let date: Date
    let locations: [Location]
    
    var body: some View {
        ZStack(alignment: .top) {
            SuperColor(Color("salmon")).saturation(2)

            HStack {
                BImage(condition: $show, image: .init(systemName: "arrow.left"))
                Spacer()
            }
            .padding(.init(top: 5, leading: 30, bottom: 0, trailing: 0))
            .offset(y: 60)
            
            VStack(spacing: 2) {
                DayLabel(date: date)
                
                VSpace(20)
                
                ForEach(locations.indexed(), id: \.1.self) { i, location in
                    DayDetailsRow(selectedIndex: self.$selectedIndex, id: i, location: location, color: Color("salmon"))
                        .contentShape(Rectangle())
                        .onTapGesture { self.setIndex(index: i) }
                        .animation(.spring())
                }
                Spacer()
            }
            .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 40))
            .offset(y: 60)
        }
    }
    
    private func setIndex(index: Int) {
        withAnimation {
            self.selectedIndex = index
        }
    }
}

struct DayDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DayDetailsView(show: .constant(true), date: Date(), locations: Location.previewLocationDetails)
    }
}
