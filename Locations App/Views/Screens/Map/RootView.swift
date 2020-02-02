//
//  ContentView.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

let screen = UIScreen.main
let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

struct RootView: View {
    @FetchRequest(
        entity: Location.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Location.arrivalDate, ascending: false)],
        predicate: .withinCurrentDate
    ) var locations: FetchedResults<Location>
    
    @State private var isFollowingUser = true
    
    var body: some View {
        ZStack(alignment: .top) {
            MapView(isFollowingUser: $isFollowingUser).edgesIgnoringSafeArea(.all)

            HStack {
                Spacer()
                CenterButton(isFollowingUser: $isFollowingUser)
                    .offset(x: -60)
            }
        }
    }
}

extension RootView {
    struct CenterButton: View {
        @Binding var isFollowingUser: Bool

        var body: some View {
            Button(action: {
                self.isFollowingUser.toggle()
            }) {
                Image(systemName: "location.circle.fill")
                .resizable()
                    .frame(width: 40, height: 40)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}


