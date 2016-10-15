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
    var imageView: UIImageView
    var redBarView: UIImageView
    override init(frame: CGRect) {
        imageView = UIImageView(image: #imageLiteral(resourceName: "battery"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        redBarView = UIImageView(image: #imageLiteral(resourceName: "redBar"))
        redBarView.translatesAutoresizingMaskIntoConstraints = false
        
        
        super.init(frame: frame)
        
        self.backgroundColor = MerithayanUI.blueGrey.base
        
        // Defining red bar
        imageView.addSubview(redBarView)
        imageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3.5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":redBarView]))
        imageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-35-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":redBarView]))
   
        // Defining yellow bar
        for _ in 0...3 {
            let yellowBarView = YellowBarView()
            yellowBarView.translatesAutoresizingMaskIntoConstraints = false
            imageView.addSubview(yellowBarView)
        }
        
        
        // Defining green bar
        for _ in 0...8 {
            let greenBarView = GreenBarView()
            greenBarView.translatesAutoresizingMaskIntoConstraints = false
            imageView.addSubview(greenBarView)
        }
        
        

        
        let viewArray = imageView.subviews
        var counter = 0
        
        // Adding yellow bar constraints
        for _ in viewArray {
            if counter == 0 {
                imageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":redBarView, "v1":viewArray[counter+1]]))
            } else if counter > 0 && counter < 5 {
                
                imageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewArray[counter-1], "v1":viewArray[counter]]))
            } else if counter == 5 {
                imageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewArray[counter-1], "v1":viewArray[counter]]))
            } else {
                
                imageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewArray[counter-1], "v1":viewArray[counter]]))
            }
            
            imageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3.5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewArray[counter]]))
            counter += 1
            
        }
        
        // Adding green bar constraints
        for _ in viewArray {
            
        }
        
        
        
    
        
        self.addSubview(imageView)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
