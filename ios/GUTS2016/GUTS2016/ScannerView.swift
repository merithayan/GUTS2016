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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
