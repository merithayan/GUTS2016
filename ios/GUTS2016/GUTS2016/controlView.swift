//
//  controlView.swift
//  GUTS2016
//
//  Created by Marius Vinickis on 15/10/16.
//  Copyright © 2016 Marius Vinickis. All rights reserved.
//

import Foundation
import UIKit




class ControlView: UIView {
    
    let image = UIImage(named: "battery")
    var imageView: UIImageView
    let viewTitle = UILabel()
    
    override init(frame: CGRect) {
        imageView = UIImageView(image: image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        self.backgroundColor = MerithayanUI.blueGrey.base
        
        self.addSubview(imageView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
