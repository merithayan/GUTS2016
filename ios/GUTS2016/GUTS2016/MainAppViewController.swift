//
//  ViewController.swift
//  GUTS2016
//  
//  This file contains the main app view controller and associated classes
//
//  Created by Tim Hull on 14/10/2016.
//  Copyright © 2016 Tim Hull. All rights reserved.
//

import UIKit
import CoreLocation

class MainAppViewController: UIViewController, CLLocationManagerDelegate {

    
    // The last time the server was updated
    var lastServerUpdate = Date()
    // How long the server wants between updates
    var timeIntervalToUpdateServer = TimeInterval(exactly: 1.0)
    
    // Create a location manager to work with the various views, and a class to act as it's delegate
    let clmanager: CLLocationManager = {
        let clmanager = CLLocationManager()
        clmanager.requestWhenInUseAuthorization()
        clmanager.desiredAccuracy = kCLLocationAccuracyBest
        clmanager.startUpdatingLocation()
        return clmanager
    }()

    // The current coordinates of t
    var currentCoords: CLLocationCoordinate2D = CLLocationCoordinate2D() {
        didSet {
            if lastServerUpdate.timeIntervalSinceNow >= timeIntervalToUpdateServer! {
                updateServer()
            }
        }
    }
    
    // The two subviews
    let controlView = ControlView()
    let scannerView = TrackerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clmanager.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.

        
        controlView.translatesAutoresizingMaskIntoConstraints = false
        scannerView.translatesAutoresizingMaskIntoConstraints = false
        
        controlView.parentView = self
        scannerView.parentView = self
        
        view.addSubview(controlView)
        view.addSubview(scannerView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":controlView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scannerView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(==v1)][v1(==v0)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scannerView, "v1":controlView]))
        
        // Deal with the initial location on the map
        // Get the user's location from CoreLocation
        let currentLocation = clmanager.location
        let currentLocationCoordinates = currentLocation?.coordinate
        
        // If there are initial coordinates, center the map on them
        if let coords = currentLocationCoordinates {
            currentCoords = coords
        }
        scannerView.scannerMap.setCenter(currentCoords, animated: true)
    }

    // When it's time to update the server run this
    func updateServer() {
        lastServerUpdate = Date()
        print("Send this stuff to server")
        print("Latitude:", currentCoords.latitude)
        print("Longitude:", currentCoords.longitude)
    }
    
    // Function called when a new location is detected
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coords = locations[0].coordinate
        scannerView.scannerMap.setCenter(coords, animated: false)
    }
    
    // Function called when a new heading is located
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        let heading = newHeading.trueHeading.description
//        print(heading)
    }
}

