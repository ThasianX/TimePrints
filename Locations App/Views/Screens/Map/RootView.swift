//
//  ContentView.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import Mapbox

let screen = UIScreen.main
let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

struct RootView: View {
    //    @FetchRequest(
    //        entity: Location.entity(),
    //        sortDescriptors: [
    //            NSSortDescriptor(keyPath: \Location.arrivalDate, ascending: false)],
    //        predicate: .withinCurrentDate
    //    ) var locations: FetchedResults<Location>
    @FetchRequest(entity: Visit.entity(), sortDescriptors: []) var visits: FetchedResults<Visit>
    
    @State private var trackingMode: MGLUserTrackingMode = .follow
    @State private var selectedLocation: String?
    @State private var showingEditTag = false
    @State private var showingLocationVisits = false
    
    private var locationVisits: [Location : [Visit]] {
        visits.reduce(into: [Location: [Visit]]()) {
            let location = Location(name: $1.name, address: $1.address)
            var visits = $0[location]
            if visits != nil {
                visits!.append($1)
            } else {
                $0[location] = [$1]
            }
        }
    }
    
    private var annotations: [LocationAnnotation] {
        locationVisits.forEac
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            MapView(trackingMode: $trackingMode, annotations: locations.map { $0.asAnnotation }, annotationsToLocations: annotationsToLocations).edgesIgnoringSafeArea(.all)
            
            HStack {
                UserLocationButton(trackingMode: $trackingMode)
                Spacer()
            }
            .padding()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

//struct UserLocationButton: UIViewRepresentable {
//    typealias UIViewType = UIButton
//    @State private var arrow: CAShapeLayer = .arrow(size: 80)
//    @Binding var trackingMode: MGLUserTrackingMode
//    let size: CGFloat = 80
//
//    func makeUIView(context: UIViewRepresentableContext<RootView.UserLocationButton>) -> UIButton {
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
//        button.backgroundColor = UIColor.white.withAlphaComponent(0.9)
//        button.layer.cornerRadius = 4
//        button.tintColor = .red
//        button.addTarget(context.coordinator, action: #selector(context.coordinator.locationButtonTapped), for: .touchUpInside)
//
//        // Update arrow for initial tracking mode
//        button.layer.addSublayer(self.arrow)
//
//        return button
//    }
//
//    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<RootView.UserLocationButton>) {
//        updateArrowForTrackingMode(mode: trackingMode)
//    }
//    // Create a new bezier path to represent the tracking mode arrow,
//    // making sure the arrow does not get drawn outside of the
//    // frame size of the UIButton.
//    private func arrowPath() -> CGPath {
//        let bezierPath = UIBezierPath()
//        let max: CGFloat = size / 2
//        bezierPath.move(to: CGPoint(x: max * 0.5, y: 0))
//        bezierPath.addLine(to: CGPoint(x: max * 0.1, y: max))
//        bezierPath.addLine(to: CGPoint(x: max * 0.5, y: max * 0.65))
//        bezierPath.addLine(to: CGPoint(x: max * 0.9, y: max))
//        bezierPath.addLine(to: CGPoint(x: max * 0.5, y: 0))
//        bezierPath.close()
//
//        return bezierPath.cgPath
//    }
//
//    // Update the arrow's color and rotation when tracking mode is changed.
//    func updateArrowForTrackingMode(mode: MGLUserTrackingMode) {
//        let activePrimaryColor = UIColor.red
//        let disabledPrimaryColor = UIColor.clear
//        let disabledSecondaryColor = UIColor.black
//        let rotatedArrow = CGFloat(0.66)
//
//        switch mode {
//        case .none:
//            updateArrow(fillColor: disabledPrimaryColor, strokeColor: disabledSecondaryColor, rotation: 0)
//        case .follow:
//            updateArrow(fillColor: disabledPrimaryColor, strokeColor: activePrimaryColor, rotation: 0)
//        case .followWithHeading:
//            updateArrow(fillColor: activePrimaryColor, strokeColor: activePrimaryColor, rotation: rotatedArrow)
//        case .followWithCourse:
//            updateArrow(fillColor: activePrimaryColor, strokeColor: activePrimaryColor, rotation: 0)
//        @unknown default:
//            fatalError("Unknown user tracking mode")
//        }
//    }
//
//    func updateArrow(fillColor: UIColor, strokeColor: UIColor, rotation: CGFloat) {
//        arrow.fillColor = fillColor.cgColor
//        arrow.strokeColor = strokeColor.cgColor
//        arrow.setAffineTransform(CGAffineTransform.identity.rotated(by: rotation))
//
//        // Re-center the arrow within the button if rotated
//        if rotation > 0 {
//            arrow.position = CGPoint(x: size / 2 + 2, y: size / 2 - 2)
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    final class Coordinator: NSObject {
//        var parent: UserLocationButton
//
//        init(_ parent: UserLocationButton) {
//            self.parent = parent
//        }
//
//        @objc func locationButtonTapped(_ sender: UIButton) {
//            var mode: MGLUserTrackingMode
//
//            switch (parent.trackingMode) {
//            case .none:
//                mode = .follow
//            case .follow:
//                mode = .followWithHeading
//            case .followWithHeading:
//                mode = .followWithCourse
//            case .followWithCourse:
//                mode = .none
//            @unknown default:
//                fatalError("Unknown user tracking mode")
//            }
//
//            parent.trackingMode = mode
//        }
//    }
//}

//extension CAShapeLayer {
//    static func arrow(size: CGFloat) -> CAShapeLayer {
//        func arrowPath() -> CGPath {
//            let bezierPath = UIBezierPath()
//            let max: CGFloat = size / 2
//            bezierPath.move(to: CGPoint(x: max * 0.5, y: 0))
//            bezierPath.addLine(to: CGPoint(x: max * 0.1, y: max))
//            bezierPath.addLine(to: CGPoint(x: max * 0.5, y: max * 0.65))
//            bezierPath.addLine(to: CGPoint(x: max * 0.9, y: max))
//            bezierPath.addLine(to: CGPoint(x: max * 0.5, y: 0))
//            bezierPath.close()
//
//            return bezierPath.cgPath
//        }
//
//        let arrow = CAShapeLayer()
//        arrow.path = arrowPath()
//        arrow.lineWidth = 2
//        arrow.lineJoin = CAShapeLayerLineJoin.round
//        arrow.bounds = CGRect(x: 0, y: 0, width: size / 2, height: size / 2)
//        arrow.position = CGPoint(x: size / 2, y: size / 2)
//        arrow.shouldRasterize = true
//        arrow.rasterizationScale = UIScreen.main.scale
//        arrow.drawsAsynchronously = true
//        return arrow
//    }
//}
