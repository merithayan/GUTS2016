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
import SocketIO
import SwiftyJSON

// The socket global variable
let socket = SocketIOClient(socketURL: URL(string: "https://montd.ngrok.io")!, config: [.log(true)])

class MainAppViewController: UIViewController, CLLocationManagerDelegate {
    
    // Setup a timer to fire server calls
    var timer = Timer()
    
    // Create a location manager to work with the various views, and a class to act as it's delegate
    let clmanager: CLLocationManager = {
        let clmanager = CLLocationManager()
        clmanager.requestWhenInUseAuthorization()
        clmanager.desiredAccuracy = kCLLocationAccuracyBest
        clmanager.startUpdatingLocation()
        return clmanager
    }()

    // The current coordinates of t
    var currentCoords: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    // The two subviews
    let controlView = ControlView()
    let scannerView = TrackerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Login the user when the view loads
        do {
            let coords = clmanager.location?.coordinate
            let jsondata: [String: String] = [
                "name" : username,
                "lat" : String(format: "%f", coords!.latitude),
                "lng" : String(format: "%f", coords!.longitude)
            ]
            
            let testString = "{\"name\":" + username + ", \"lat\":" + String(format: "%f", coords!.latitude) + ", \"lng\":" + String(format: "%f", coords!.longitude) + "}"
            
            let jsonifiedUsername = try JSONSerialization.data(withJSONObject: jsondata, options: .prettyPrinted)
            
            print(String(data: jsonifiedUsername, encoding: String.Encoding.utf8)!)
            socket.emit("login", testString)
        } catch let error as Error {
            print(error)
            fatalError()
        }
        
        clmanager.delegate = self
        
        // Setup the timer for the server updates
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateServer), userInfo: nil, repeats: true)
        
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
        let dataDictionary = [
            "lat": currentCoords.latitude,
            "lng": currentCoords.longitude
        ]
        
        do {
            let jsonifiedData = try JSONSerialization.data(withJSONObject: dataDictionary, options: .prettyPrinted)
            print("OUTGOING DATA *******************")
            try print(JSONSerialization.jsonObject(with: jsonifiedData, options: .mutableContainers) as! [String: Any])
            print("*********************************")
            //socket.connect()
            socket.emit("update-player", jsonifiedData)
        } catch let error as Error {
            print(error)
        }
        
    }
    
    // Function called when a new location is detected
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coords = locations[0].coordinate
        scannerView.scannerMap.setCenter(coords, animated: false)
        currentCoords = coords
    }
    
    // Function called when a new heading is located
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        let heading = newHeading.trueHeading.description
//        print(heading)
    }
}

