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
        
        scannerMap.delegate = self
        
        self.addSubview(scannerMap)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scannerMap]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scannerMap]))
        
        self.backgroundColor = MerithayanUI.green.base
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing ‘pisa’ annotation image, if it exists.
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "ping")
        
        if annotationImage == nil {
            // Leaning Tower of Pisa by Stefan Spieler from the Noun Project.
            var image = UIImage(named: "pingRed")!
            
            // The anchor point of an annotation is currently always the center. To
            // shift the anchor point to the bottom of the annotation, the image
            // asset includes transparent bottom padding equal to the original image
            // height.
            //
            // To make this padding non-interactive, we create another image object
            // with a custom alignment rect that excludes the padding.
            image = image.withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            
            // Initialize the ‘pisa’ annotation image with the UIImage we just loaded.
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pingRed")
        }
        
        return annotationImage
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
