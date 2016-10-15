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
import SocketIO

class TrackerView: UIView, MGLMapViewDelegate {
    
    // Parent view, used to access single location manager instance
    var parentView: MainAppViewController? = nil
    // The map to be used as the scanner
    var scannerMap: MGLMapView
    
    
    override init(frame: CGRect) {
        
        // Setup the scanner map
        scannerMap = MGLMapView()
        
        parentView?.currentCoords = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        scannerMap.isScrollEnabled = false
        scannerMap.styleURL = MGLStyle.darkStyleURL(withVersion: 9)
        scannerMap.translatesAutoresizingMaskIntoConstraints = false
        scannerMap.setUserTrackingMode(MGLUserTrackingMode.follow, animated: true)
        scannerMap.zoomLevel = 17
        
        super.init(frame: frame)
        
        self.addSubview(scannerMap)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scannerMap]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scannerMap]))
        
        self.backgroundColor = MerithayanUI.green.base
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x:0, y:0, width:30.0, height:30.0)
            
            
            // Set the annotation view’s background color to a value determined by its longitude.
            annotationView!.backgroundColor = MerithayanUI.green.lighten3
        }
        
        return annotationView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
}

// Class for the Radar view
class TrackerRadarAnnotation: MGLAnnotationView {
    init(reuseIdentifier: String, size: CGFloat) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // This property prevents the annotation from changing size when the map is tilted.
        scalesWithViewingDistance = false
        
        // Begin setting up the view.
        frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        backgroundColor = MerithayanUI.blueGrey.lighten5
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = size / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
