// Kevin Li - 8:47 AM - 2/18/20

import Foundation
import Mapbox

extension MGLMapView {
    static func makeDefault(with delegate: MGLMapViewDelegate, tintColor: UIColor) -> MGLMapView {
        let styleURL = URL(string: "mapbox://styles/mapbox/navigation-preview-night-v4")!
        let mapView = MGLMapView(frame: .zero, styleURL: styleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = delegate
        mapView.tintColor = tintColor
        mapView.attributionButton.tintColor = .lightGray
        mapView.showsUserLocation = true
        mapView.showsUserHeadingIndicator = true
        return mapView
    }
}
