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

class MainAppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let controlView = ControlView()
        let scannerView = TrackerView()
        
        controlView.translatesAutoresizingMaskIntoConstraints = false
        scannerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(controlView)
        view.addSubview(scannerView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":controlView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scannerView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(==v1)][v1(==v0)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scannerView, "v1":controlView]))
    }

}

