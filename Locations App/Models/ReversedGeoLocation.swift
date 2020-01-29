//
//  ReversedGeoLocation.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import CoreLocation

struct ReversedGeoLocation {
    let name: String            // eg. Apple Inc.
    let streetName: String      // eg. Infinite Loop
    let streetNumber: String    // eg. 1
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US

    var address: String {
        return "\(streetNumber) \(streetName), \(city), \(state) \(zipCode) \(isoCountryCode)"
    }

    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? "No Name"
        self.streetName     = placemark.thoroughfare ?? "No Street Name"
        self.streetNumber   = placemark.subThoroughfare ?? "No Street Number"
        self.city           = placemark.locality ?? "No City"
        self.state          = placemark.administrativeArea ?? "No State"
        self.zipCode        = placemark.postalCode ?? "No Zip Code"
        self.country        = placemark.country ?? "No Country"
        self.isoCountryCode = placemark.isoCountryCode ?? "No Country Code"
    }
}
