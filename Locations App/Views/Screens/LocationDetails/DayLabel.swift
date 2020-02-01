//
//  DayLabel.swift
//  Locations App
//
//  Created by Kevin Li on 2/1/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct DayLabel: View {
    let date: Date
    
    var dayOfMonth: String {
        let day: String
        if Calendar.current.isDateInToday(date) {
            day = "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            day = "Yesterday"
        } else if Calendar.current.isDateInTomorrow(date) {
            day = "Tomorrow"
        } else {
            day = date.fullDayOfWeek
        }
        return day
    }
    
    var body: some View {
        VStack {
            Text(dayOfMonth.uppercased())
                .font(.title)
                .fontWeight(.bold)
                .tracking(5)
            Text(date.fullMonthWithDay.uppercased())
                .font(.caption)
        }
    }
}
struct DayLabel_Previews: PreviewProvider {
    static var previews: some View {
        DayLabel(date: Date())
    }
}
