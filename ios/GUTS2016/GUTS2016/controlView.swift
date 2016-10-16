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
    let powerUpButton = UIButton(type: .custom)
    
    var batteryBarContainerView: UIView
    
    var youHit: String? = nil {
        didSet {
            youHitLabel.isHidden = false
            if let newyouHit = youHit {
                youHitLabel.text = "You hit: " + newyouHit
            }
            
        }
    }
    
    var hitYou: String? = nil {
        didSet {
            hitYouLabel.isHidden = false
            if let newhityou = hitYou {
                hitYouLabel.text = newhityou + " hit you!"
            }
        }
    }
    
    let youHitLabel = UILabel()
    let hitYouLabel = UILabel()
    let fireButton  = UIButton(type: .custom)
    let experienceCounter = UILabel()
    
    override init(frame: CGRect) {
        batteryView = UIImageView(image: #imageLiteral(resourceName: "battery"))
        batteryView.translatesAutoresizingMaskIntoConstraints = false
        batteryView.contentMode = UIViewContentMode.scaleAspectFit;
        
        batteryBarContainerView = UIView(frame: CGRect(x: 0, y: 0, width: batteryView.bounds.width*0.5, height: batteryView.bounds.height))

        batteryBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let screenWidth = UIScreen.main.bounds.width

        redBarView = UIImageView(image: #imageLiteral(resourceName: "redBar"))
        redBarView.translatesAutoresizingMaskIntoConstraints = false
        redBarView.contentMode = UIViewContentMode.scaleAspectFit;
        
        
        
        fireButton.setImage(#imageLiteral(resourceName: "fireButton"), for: UIControlState.normal)
        fireButton.translatesAutoresizingMaskIntoConstraints = false
        fireButton.isHighlighted = false
        

        powerUpButton.setImage(#imageLiteral(resourceName: "powerUpButtonActive"), for: UIControlState.normal)
        powerUpButton.translatesAutoresizingMaskIntoConstraints = false

        // Hit Labels
        youHitLabel.textColor = MerithayanUI.green.lighten3
        hitYouLabel.textColor = MerithayanUI.green.lighten3
        experienceCounter.textColor = MerithayanUI.green.lighten5
        
        youHitLabel.translatesAutoresizingMaskIntoConstraints = false
        hitYouLabel.translatesAutoresizingMaskIntoConstraints = false
        experienceCounter.translatesAutoresizingMaskIntoConstraints = false
        
        youHitLabel.isHidden = true
        hitYouLabel.isHidden = true
        
        youHitLabel.textAlignment = .center
        hitYouLabel.textAlignment = .center
        experienceCounter.textAlignment = .center
        
        experienceCounter.font = UIFont.boldSystemFont(ofSize: 20)
        experienceCounter.text = "XP: 0"
        
        super.init(frame: frame)
        
        addSubview(youHitLabel)
        addSubview(hitYouLabel)
        addSubview(experienceCounter)
        
        
        fireButton.addTarget(self, action: #selector(fireAction), for: .touchUpInside)
        powerUpButton.addTarget(self, action: #selector(powerUpAction), for: .touchUpInside)
        
        self.backgroundColor = MerithayanUI.blueGrey.base
   
        batteryView.addSubview(batteryBarContainerView)
        
        var margin: Int
        
        switch UIDevice.current.name {
        case "Mario's iPhone 6":
            margin = 100
        case "Tim's iPhone":
            margin = 120
        default:
            margin = 100
        }
        
        
        // BatteryView -> BatteryBarContainer constraints
        batteryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":batteryBarContainerView]))
        batteryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(margin)-[v0]-(margin)-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: ["margin":margin], views: ["v0":batteryBarContainerView]))
        batteryView.centerXAnchor.constraint(equalTo: batteryBarContainerView.centerXAnchor).isActive = true
        
        reloadBatteryView()
        
        // Adding batteryView to the controlView
        addSubview(batteryView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":batteryView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":batteryView]))
        
        
        // Adding fireView to the controlView
        addSubview(fireButton)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-10-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":batteryView, "v1":fireButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":fireButton]))
        
        
        // Adding powerUpView to the controlView
        addSubview(powerUpButton)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-10-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":fireButton, "v1":powerUpButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":powerUpButton]))
        
        
        
        // Text constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-10-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":powerUpButton, "v1":experienceCounter]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":experienceCounter]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-20-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hitYouLabel, "v1":experienceCounter]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hitYouLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-10-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hitYouLabel, "v1":youHitLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":youHitLabel]))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fireAction(){
        if player.canIfire {
            socket.emit("fire", myId)
            player.canIfire = false
            fireButton.isHighlighted = false
            let timer = Timer.init(timeInterval: 0.5, repeats: false, block: {(timer) in
                player.canIfire = true
                self.fireButton.isHighlighted = true
            })
            
        } else {
            
        }
        
    }
    
    func powerUpAction(){
        if player.hasEmp {
            powerUpButton.setImage(#imageLiteral(resourceName: "powerUpButton"), for: UIControlState.normal)
            socket.emit("emp")
            player.hasEmp = false
            print("I fired an EMP")
        }
        print("I have no emp :( ")
    }
    
    func reactivateEmp() {
        powerUpButton.setImage(#imageLiteral(resourceName: "powerUpButtonActive"), for: UIControlState.normal)
        print("I now have an emp again :) ")
    }
    
    func deactivateEmp() {
        powerUpButton.setImage(#imageLiteral(resourceName: "powerUpButton"), for: .normal)
    }
    func reloadBatteryView() {
        
        if (player.health <= 0) {
            return
        }
        
        let subviews = batteryBarContainerView.subviews
        for view in subviews {
            view.removeFromSuperview()
        }
        if player.health > 0 {
            // Defining red bar
            batteryBarContainerView.addSubview(redBarView)
            batteryBarContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2.5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":redBarView]))
            batteryBarContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":redBarView]))
        }
        
        if player.health > 1 {
            // Defining yellow bar
            for _ in 1...(player.health/2+2) {
                let yellowBarView = YellowBarView()
                yellowBarView.translatesAutoresizingMaskIntoConstraints = false
                batteryBarContainerView.addSubview(yellowBarView)
            }
        }
        
        if player.health > 2 {
            // Defining green bar
            for _ in (player.health/2)...(player.health+1) {
                let greenBarView = GreenBarView()
                greenBarView.translatesAutoresizingMaskIntoConstraints = false
                batteryBarContainerView.addSubview(greenBarView)
            }
        }
//        if player.health > 3 {
//            // Defining green bar
//            for _ in (player.health)-2...(player.health*2)+1 {
//                let greenBarView = GreenBarView()
//                greenBarView.translatesAutoresizingMaskIntoConstraints = false
//                batteryBarContainerView.addSubview(greenBarView)
//            }
//        }

        let viewArray = batteryBarContainerView.subviews

        if viewArray.count <= 1 {
            return
        }
        
        var counter = 0
        
        // Adding bar constraints
        for _ in viewArray {
            if counter == 0 {
                batteryBarContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":redBarView, "v1":viewArray[counter+1]]))
            } else {
                
                batteryBarContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewArray[counter-1], "v1":viewArray[counter]]))
            }
            
            batteryBarContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2.5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewArray[counter]]))
            counter += 1
            
        }
    }
}
