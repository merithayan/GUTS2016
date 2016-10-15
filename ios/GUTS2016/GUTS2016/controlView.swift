//
//  controlView.swift
//  GUTS2016
//
//  Created by Marius Vinickis on 15/10/16.
//  Copyright © 2016 Marius Vinickis. All rights reserved.
//

import Foundation
import UIKit

// Defining YellowBar class
class YellowBarView: UIImageView {
    let yellowBarView = UIImageView(image: #imageLiteral(resourceName: "yellowBar"))
    init() {
        super.init(image: #imageLiteral(resourceName: "yellowBar"))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GreenBarView: UIImageView {
    let yellowBarView = UIImageView(image: #imageLiteral(resourceName: "greenBar"))
    init() {
        super.init(image: #imageLiteral(resourceName: "greenBar"))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ControlView: UIView {
    
    var parentView: MainAppViewController? = nil
    
    var batteryView: UIImageView
    var redBarView: UIImageView
    override init(frame: CGRect) {
        batteryView = UIImageView(image: #imageLiteral(resourceName: "battery"))
        batteryView.translatesAutoresizingMaskIntoConstraints = false
        redBarView = UIImageView(image: #imageLiteral(resourceName: "redBar"))
        redBarView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let fireButton  = UIButton(type: .custom)
        fireButton.setImage(#imageLiteral(resourceName: "fireButton"), for: UIControlState.normal)
        fireButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        super.init(frame: frame)
        
        fireButton.addTarget(self, action: #selector(fireAction), for: .touchUpInside)
        
        
        
        self.backgroundColor = MerithayanUI.blueGrey.base
        
        // Defining red bar
        batteryView.addSubview(redBarView)
        batteryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2.5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":redBarView]))
        batteryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-22.5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":redBarView]))
   
        // Defining yellow bar
        for _ in 0...3 {
            let yellowBarView = YellowBarView()
            yellowBarView.translatesAutoresizingMaskIntoConstraints = false
            batteryView.addSubview(yellowBarView)
        }
        
        
        // Defining green bar
        for _ in 0...8 {
            let greenBarView = GreenBarView()
            greenBarView.translatesAutoresizingMaskIntoConstraints = false
            batteryView.addSubview(greenBarView)
        }
        
        
        let viewArray = batteryView.subviews
        var counter = 0
        
        // Adding yellow & green bar constraints
        for _ in viewArray {
            if counter == 0 {
                batteryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":redBarView, "v1":viewArray[counter+1]]))
            } else if counter > 0 && counter < 5 {
                
                batteryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewArray[counter-1], "v1":viewArray[counter]]))
            } else if counter == 5 {
                batteryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewArray[counter-1], "v1":viewArray[counter]]))
            } else {
                
                batteryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewArray[counter-1], "v1":viewArray[counter]]))
            }
            
            batteryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2.5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewArray[counter]]))
            counter += 1
            
        }
        
        
        
        // Adding batteryView to the controlView
        addSubview(batteryView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":batteryView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":batteryView]))
        
        
        // Adding fireView to the controlView
        addSubview(fireButton)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-10-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":batteryView, "v1":fireButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-22.5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":fireButton]))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fireAction(){
        socket.emit("fire", myId)
    }
}
