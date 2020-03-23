import SwiftUI

struct TransientAlertView: View {
    @ObservedObject var tagState: TagCoreState

    var body: some View {
        HStack {
            deletedTagMessageDefaultsAlertMessage
        }
    }

    private var deletedTagMessageDefaultsAlertMessage: some View {
        Group {
            if tagState.alert.isRemoval {
                deletedTagName
                    .padding(.trailing, 8)

                revertButton
                    .padding(8)
                    .background(tagState.alert.deletedTag.uiColor.color)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } else {
                alertMessageText
            }
        }
    }

    private var deletedTagName: some View {
        Text("Deleted: \(tagState.alert.deletedTag.name)")
            .font(.system(size: 20))
            .foregroundColor(.white)
            .animation(nil)
    }

    private var revertButton: some View {
        Button(action: tagState.revertDeletion) {
            Text("Revert")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .animation(nil)
        }
    }

    private var alertMessageText: some View {
        Text(tagState.alert.message)
            .foregroundColor(.white)
            .animation(nil)
    }
}

struct TransientAlertView_Previews: PreviewProvider {
    static var previews: some View {
        TransientAlertView(tagState: .init())
    }
}
