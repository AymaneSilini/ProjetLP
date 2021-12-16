//
//  PoiAnnotationView.swift
//  CityHub
//
//  Created by Aymane Silini on 09/12/2021.
//
import Foundation

import MapKit

class PoiAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if let poi = newValue as? Poi {
                switch poi.poiType {
                case .cinema:
                    markerTintColor = UIColor.blue
                    glyphText = "🎦"
                case .restauration:
                    markerTintColor = UIColor.green
                    glyphText = "🍝"
                case .transport:
                    markerTintColor = UIColor.red
                    glyphText = "🚊"
                case .ecole:
                    markerTintColor = UIColor.orange
                    glyphText = "📚"
                }
                canShowCallout = true
                calloutOffset = CGPoint(x: -5, y: 5)
                rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        }
    }
    
}
