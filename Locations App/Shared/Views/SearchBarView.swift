// Kevin Li - 5:23 PM - 5/30/20

import SwiftUI

struct SearchBarView: View {
    @State private var showCancelButton: Bool = false

    @Binding var query: String
    let placeholder: String
    let color: Color

    var body: some View {
        searchView
    }

    private var searchView: some View {
        HStack {
            HStack {
                magnifyingImage
                searchTextField
                resetFilterButton
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.gray)
            .background(color.saturation(0.5))
            .cornerRadius(10.0)

            if showCancelButton {
                cancelButton
            }
        }
        .padding(.horizontal)
    }

    private var magnifyingImage: some View {
        Image(systemName: "magnifyingglass")
    }

    private var searchTextField: some View {
        TextField(placeholder, text: $query, onEditingChanged: onEditingChanged)
    }

    private func onEditingChanged(_ isEditing: Bool) {
        showCancelButton = true
    }

    private var resetFilterButton: some View {
        Button(action: {
            self.resetFilter()
        }) {
            Image(systemName: "xmark.circle.fill")
                .fade(if: query.isEmpty)
        }
    }

    private func resetFilter() {
        query = ""
    }

    private var cancelButton: some View {
        Button("Cancel") {
            UIApplication.shared.endEditing(true) // this must be placed before the other commands here
            self.query = ""
            self.showCancelButton = false
        }
        .foregroundColor(.white)
    }
}
