//
//  ScannerView.swift
//  GUTS2016
//
//  Created by Tim Hull on 14/10/2016.
//  Copyright © 2016 Tim Hull. All rights reserved.
//

import Foundation
import UIKit

class TrackerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = MerithayanUI.amber.base
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
