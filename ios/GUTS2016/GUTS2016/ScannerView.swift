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

class TrackerView: UIView, CLLocationManagerDelegate {
    
    var scannerMap: MGLMapView
    
    override init(frame: CGRect) {
        scannerMap = MGLMapView()
        
        super.init(frame: frame)
        
        // Get the users location to initially set the map
        let clmanager = CLLocationManager()
        clmanager.activityType = .other

        //clmanager.allowDeferredLocationUpdates(untilTraveled: <#T##CLLocationDistance#>, timeout: <#T##TimeInterval#>)
        clmanager.desiredAccuracy = kCLLocationAccuracyBest
        clmanager.startMonitoringSignificantLocationChanges()
        
        let currentLocation = clmanager.location
        let currentLocationCoordinates = currentLocation?.coordinate
        
        scannerMap.styleURL = MGLStyle.darkStyleURL(withVersion: 9)
        scannerMap.translatesAutoresizingMaskIntoConstraints = false
        
        scannerMap.setUserTrackingMode(MGLUserTrackingMode.follow, animated: true)
        
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
    }
}
