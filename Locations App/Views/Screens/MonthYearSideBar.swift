//
//  MonthSideBar.swift
//  Locations App
//
//  Created by Kevin Li on 1/31/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct MonthYearSideBar: View {
    let date: Date
    
    var body: some View {
        Text(date.fullMonthWithYear)
            .tracking(10)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .rotationEffect(.init(degrees: -90))
    }
}

struct MonthSideBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            MonthYearSideBar(date: Date())
        }
    }
}
