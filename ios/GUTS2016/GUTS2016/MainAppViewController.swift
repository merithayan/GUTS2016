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
import Mapbox

// The socket global variable
// c9092951
let socket = SocketIOClient(socketURL: URL(string: "https://c9092951.ngrok.io")!, config: [])

// Player variables
var health = 3
var exp = 0
var myId = ""

var otherPlayerLocations: [String:Any] = [:]

class MainAppViewController: UIViewController, CLLocationManagerDelegate {
    
    // Setup a timer to fire server calls
    var timer = Timer()
    var timer2 = Timer()
    
    // Create a location manager to work with the various views, and a class to act as it's delegate
    let clmanager: CLLocationManager = {
        let clmanager = CLLocationManager()
        clmanager.requestWhenInUseAuthorization()
        clmanager.desiredAccuracy = kCLLocationAccuracyBest
        clmanager.startUpdatingLocation()
        clmanager.startUpdatingHeading()
        return clmanager
    }()

    // The current coordinates of t
    var currentCoords: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var currentAngle: CLLocationDirection = CLLocationDirection()
    
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
            
            let writingOptions = JSONSerialization.WritingOptions.init(rawValue: 0)
            
            let jsonifiedUsername = try JSONSerialization.data(withJSONObject: jsondata, options: writingOptions)
            let string = String(data: jsonifiedUsername, encoding: String.Encoding.utf8)!
            
            socket.emit("login", string)
        } catch let error {
            print(error)
            fatalError()
        }
        
        clmanager.delegate = self
        
        // Setup the timer for the server updates
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateServer), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(radarUpdate), userInfo: nil, repeats: true)
        
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
        let currentheading = clmanager.heading
        
        // If there are initial coordinates, center the map on them
        if let coords = currentLocationCoordinates {
            currentCoords = coords
        }
        if let heading = currentheading {
            currentAngle = heading.magneticHeading
        }
        
        scannerView.scannerMap.setCenter(currentCoords, animated: true)
        

        
    }

    // When it's time to update the server run this
    func updateServer() {
        let dataDictionary = [
            "lat": currentCoords.latitude,
            "lng": currentCoords.longitude,
            "angle": currentAngle,
            "id": myId
        ] as [String : Any]
        
        do {
            let writingOptions = JSONSerialization.WritingOptions.init(rawValue: 0)
            let jsonifiedData = try JSONSerialization.data(withJSONObject: dataDictionary, options: writingOptions)
            let string = String(data: jsonifiedData, encoding: String.Encoding.utf8)!
            socket.emit("update-player", string)
        } catch let error {
            print(error)
        }
        
    }
    
    // Function to reload the radar
    func radarUpdate() {
        // Add the pings to the map
        var mapMarkers: [MGLAnnotation] = []
        if let things = self.scannerView.scannerMap.annotations {
            mapMarkers = things
        }
        scannerView.scannerMap.removeAnnotations(mapMarkers)
        var pointAnnotations = [MGLPointAnnotation]()
        for player in otherPlayerLocations {
            // Player has
            // ids {
            //    name
            //    lat
            //    lng
            // }
            let id = player.key
            let data = player.value as! [String: Any]
            let playerLat = data["lat"] as! Double
            let playerLng = data["lng"] as! Double
            
            let playerCoords = CLLocationCoordinate2DMake(playerLat, playerLng)
            let point = MGLPointAnnotation()
            point.coordinate = playerCoords
            pointAnnotations.append(point)
        }
        scannerView.scannerMap.addAnnotations(pointAnnotations)
    }
    
    // Function called when a new location is detected
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coords = locations[0].coordinate
        scannerView.scannerMap.setCenter(coords, animated: false)
        currentCoords = coords
        
        
    }
    
    // Function called when a new heading is located
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading.magneticHeading
        currentAngle = heading
    }
}


