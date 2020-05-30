// Kevin Li - 10:35 PM - 5/29/20

import SwiftUI

struct LocationNameTextField: View {
    let location: Location

    let textColor: Color
    let onEditingChanged: (Bool) -> Void

    var body: some View {
        locationNameTextField
            .id(location)
            .padding(.vertical)
            .padding(.horizontal, 32)
    }

    private var locationNameTextField: some View {
        let nameInput = Binding(
            get: { self.location.name },
            set: { self.location.setName($0) })

        return _LocationNameTextField(
            nameInput: nameInput,
            textColor: textColor,
            onEditingChanged: onEditingChanged)
    }
}

private struct _LocationNameTextField: View {
    @Binding var nameInput: String

    let textColor: Color
    let onEditingChanged: (Bool) -> Void

    var body: some View {
        TextField("Location Name", text: $nameInput, onEditingChanged: onEditingChanged)
            .foregroundColor(textColor)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}
