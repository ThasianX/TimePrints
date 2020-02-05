//
//  TransientAlert.swift
//  Locations App
//
//  Created by Kevin Li on 2/5/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct TransientAlert: View {
    let deletedTag: Tag?
    let alertMessage: String
    let revert: () -> Void
    
    var body: some View {
        HStack {
            if deletedTag != nil {
                Text("Deleted: \(deletedTag!.name)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.trailing, 8)
                
                Button(action: revert) {
                    Text("Revert")
                        .font(.headline)
                        .foregroundColor(Color(deletedTag?.uiColor ?? .clear))
                }
            } else {
                Text(alertMessage)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

struct TransientAlert_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransientAlert(deletedTag: nil, alertMessage: "Cannot delete default tag", revert: { })
            TransientAlert(deletedTag: .preview, alertMessage: "", revert: { })
        }
    }
}
