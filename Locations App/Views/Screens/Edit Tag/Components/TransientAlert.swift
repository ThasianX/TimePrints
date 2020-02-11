import SwiftUI

struct TransientAlert: View {
    let deletedTag: Tag?
    let alertMessage: String
    let revert: () -> Void
    
    var body: some View {
        HStack {
            deletedTagMessageDefaultsAlertMessage
        }
        .padding()
    }
}

private extension TransientAlert {
    private var deletedTagMessageDefaultsAlertMessage: some View {
        Group {
            if deletedTagExists {
                deletedTagName
                    .padding(.trailing, 8)
                
                revertButton
            } else {
                alertMessageText
            }
        }
    }
    
    private var deletedTagName: some View {
        Text("Deleted: \(deletedTag!.name)")
            .font(.headline)
            .foregroundColor(.white)
    }
    
    private var revertButton: some View {
        Button(action: revert) {
            Text("Revert")
                .font(.headline)
                .foregroundColor(Color(deletedTag?.uiColor ?? .clear))
        }
    }
    
    private var alertMessageText: some View {
        Text(alertMessage)
            .foregroundColor(.white)
    }
}

private extension TransientAlert {
    private var deletedTagExists: Bool {
        deletedTag != nil
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
