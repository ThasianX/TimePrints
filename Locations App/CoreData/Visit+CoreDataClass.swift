//
//  Location+CoreDataClass.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation
import SwiftUI
import Mapbox

@objc(Location)
public class Visit: NSManagedObject {
    // MARK: - CRUD
    private class func newVisit() -> Visit {
        Visit(context: CoreData.stack.context)
    }
    
    private class func create(_ coordinates: CLLocationCoordinate2D, arrivalDate: Date, departureDate: Date, place: CLPlacemark) -> Visit {
        let visit = newVisit()
        visit.latitude = coordinates.latitude
        visit.longitude = coordinates.longitude
        visit.arrivalDate = arrivalDate
        visit.departureDate = departureDate
        let reversedGeoLocation = ReversedGeoLocation(with: place)
        visit.address = reversedGeoLocation.address
        visit.name = reversedGeoLocation.name
        visit.tag = Tag.getDefault()
        CoreData.stack.save()
        
        return visit
    }
    
    @discardableResult
    class func create(visit: CLVisit, place: CLPlacemark) -> Visit {
        create(visit.coordinate, arrivalDate: visit.arrivalDate, departureDate: visit.departureDate, place: place)
    }
    
    func addNotes(_ notes: String) {
        self.notes = notes
        CoreData.stack.save()
    }
    
    func favorite() {
        self.isFavorite.toggle()
        CoreData.stack.save()
    }
    
    func setTag(tag: Tag) {
        self.tag = tag
        let fetchRequest: NSFetchRequest<Visit> = Visit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%@ == name", self.name)
        do {
            let locations = try CoreData.stack.context.fetch(fetchRequest)
            locations.forEach { $0.tag = tag }
        } catch {
            fatalError("Location entity must exist")
        }
        
        CoreData.stack.save()
    }
    
    func delete() -> Visit {
        let visit = self
        CoreData.stack.context.delete(self)
        return visit
    }
    
    // MARK: - Convenience
    var visitDuration: String {
        self.arrivalDate.timeOnlyWithPadding + " ➝ " + self.departureDate.timeOnlyWithPadding
    }
    
    var accent: UIColor {
        UIColor(self.tag.color)
    }
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: self.latitude, longitude: self.longitude)
    }
    
    var asAnnotation: MGLPointAnnotation {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = self.coordinate
        annotation.title = self.name
        annotation.subtitle = self.arrivalDate.abbreviatedMonthWithDayYear + " " + self.visitDuration
        return annotation
    }
}

extension Visit {
    // MARK: - Preview
    class var preview: Visit {
        let visit = newVisit()
        visit.latitude = 12.9716
        visit.longitude = 77.5946
        visit.arrivalDate = Date.random(range: 1000)
        visit.departureDate = Date().addingTimeInterval(.random(in: 100...2000))
        visit.address = "1 Infinite Loop, Cupertino, California"
        visit.notes = "Had a great time visiting my friend, who works here. The food is amazing and the pay seems great."
        visit.name = "Apple INC"
        visit.isFavorite = true
        visit.tag = Tag.create(name: "Visit", color: .charcoal)
        CoreData.stack.save()
        return visit
    }
    
    class var previewVisits: [Visit] {
        var visits = [Visit]()
        for _ in 0..<10 {
            let date = Date.random(range: 100)
            for _ in 0..<10 {
                let visit = preview
                visit.arrivalDate = date
                visits.append(visit)
            }
        }
        return visits
    }
    
    class var previewVisitDetails: [Visit] {
        var visits = [Visit]()
        let date = Date.random(range: 100)
        for _ in 0..<5 {
            let visit = preview
            visit.arrivalDate = date
            visits.append(visit)
        }
        return visits
    }
}
