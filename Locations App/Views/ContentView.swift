//
//  ContentView.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(
        entity: Location.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Location.arrivalDate, ascending: false)],
        predicate: .withinCurrentDate
    ) var locations: FetchedResults<Location>
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
