import SwiftUI
import Mapbox

struct UserLocationButton: View {
    @Binding var trackingMode: MGLUserTrackingMode
    @Binding var locationControl: AppState.LocationControl

    let color: Color
    
    var shouldRotate: Bool {
        trackingMode == .followWithHeading
    }
    
    var body: some View {
        trackingModeButton
    }

    private var trackingModeButton: some View {
        Button(action: updateTrackingMode) {
            locationFillImage
                .foregroundColor(color)
                .rotationEffect(shouldRotate ? .init(degrees: -45) : .init(degrees: 0))
                .animation(.spring(response: 0.75, dampingFraction: 0.825, blendDuration: 0))
        }
    }

    private var locationFillImage: some View {
        Image(systemName: "location.fill")
            .resizable()
            .frame(width: 40, height: 40)
    }
    
    private func updateTrackingMode() {
        var mode: MGLUserTrackingMode
        
        switch trackingMode {
        case .follow:
            mode = .followWithHeading
        case .followWithHeading:
            mode = .follow
        default:
            fatalError("Other tracking modes not supported")
        }

        withAnimation {
            self.trackingMode = mode
            self.locationControl.reset(stayAtCurrent: false)
        }
    }
}

struct UserLocationButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserLocationButton(trackingMode: .constant(.follow), locationControl: .constant(.init()), color: .pink)
            UserLocationButton(trackingMode: .constant(.followWithHeading), locationControl: .constant(.init()), color: .pink)
        }
    }
}
