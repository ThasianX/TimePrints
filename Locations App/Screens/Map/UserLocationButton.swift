import SwiftUI
import Mapbox

struct UserLocationButton: View {
    @Binding var trackingMode: MGLUserTrackingMode
    @Binding var stayAtLocation: Bool
    @Binding var activeVisitLocation: Location?

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
                .rotationEffect(shouldRotate ? .init(degrees: -45) : .init(degrees: 0))
                .animation(.spring(response: 0.75, dampingFraction: 0.825, blendDuration: 0))
        }
    }

    private var locationFillImage: some View {
        Image(systemName: "location.fill")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(color)
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
            self.stayAtLocation = false
            self.activeVisitLocation = nil
        }
    }
}

struct UserLocationButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserLocationButton(trackingMode: .constant(.follow), stayAtLocation: .constant(false), activeVisitLocation: .constant(nil), color: .pink)
            UserLocationButton(trackingMode: .constant(.followWithHeading), stayAtLocation: .constant(false), activeVisitLocation: .constant(nil), color: .pink)
        }
    }
}
