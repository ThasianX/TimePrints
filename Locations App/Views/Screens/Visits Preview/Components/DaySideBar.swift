//
//  DaySideBar.swift
//  Locations App
//
//  Created by Kevin Li on 1/31/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct DaySideBar: View {
    let date: Date
    
    var body: some View {
        VStack {
            Text(date.abbreviatedDayOfWeek.uppercased())
                .font(.caption)
                .foregroundColor(.gray)
            Text(date.dayOfMonth)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(width: 35)
    }
}

struct DaySideBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            DaySideBar(date: Date())
        }
    }
}
