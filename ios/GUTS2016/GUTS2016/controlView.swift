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
    let confirmButton = UIButton()
    
    override init(frame: CGRect) {
        imageView = UIImageView(image: image)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
