//
//  ScannerView.swift
//  GUTS2016
//
//  Created by Tim Hull on 14/10/2016.
//  Copyright © 2016 Tim Hull. All rights reserved.
//

import Foundation
import UIKit
import Mapbox
import CoreLocation

class TrackerView: UIView, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    var scannerMap: MGLMapView
    var clmanager: CLLocationManager
    
    override init(frame: CGRect) {
        
        // Setup the scanner map
        scannerMap = MGLMapView()
        clmanager = CLLocationManager()
        
        scannerMap.isScrollEnabled = false
        scannerMap.styleURL = MGLStyle.darkStyleURL(withVersion: 9)
        scannerMap.translatesAutoresizingMaskIntoConstraints = false
        scannerMap.setUserTrackingMode(MGLUserTrackingMode.follow, animated: true)
        scannerMap.zoomLevel = 15
        
        super.init(frame: frame)
        
        // Set up the CoreLocation Manager
        
        clmanager.requestWhenInUseAuthorization()
        clmanager.desiredAccuracy = kCLLocationAccuracyBest
        clmanager.startUpdatingLocation()
        clmanager.startUpdatingHeading()
        clmanager.delegate = self
        
        // Get the user's location from CoreLocation
        let currentLocation = clmanager.location
        let currentLocationCoordinates = currentLocation?.coordinate
        
        // If there are initial coordinates, center the map on them
        if let coords = currentLocationCoordinates {
            scannerMap.setCenter(coords, animated: true)
        }
        
        
        self.addSubview(scannerMap)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scannerMap]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scannerMap]))
        
        self.backgroundColor = MerithayanUI.green.base
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coords = locations[0].coordinate
        scannerMap.setCenter(coords, animated: false)
        scannerMap.latitude = coords.latitude
        scannerMap.longitude = coords.longitude
        print("Location Manager Updated Location:")
        print(coords)
        scannerMap.zoomLevel = 20
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading.trueHeading.description
        print(heading)
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        let coords = userLocation?.coordinate
        if let coords = coords {
            scannerMap.setCenter(coords, animated: false)
            print("Map View Updated Location:")
            print(coords)
            scannerMap.latitude = coords.latitude
            scannerMap.longitude = coords.longitude
        }
        
    }
}

