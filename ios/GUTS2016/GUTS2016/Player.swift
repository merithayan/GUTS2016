//
//  Player.swift
//  GUTS2016
//
//  Created by Tim Hull on 15/10/2016.
//  Copyright © 2016 Tim Hull. All rights reserved.
//

import Foundation
import UIKit

let player = Player()

class Player {
    var mainView: MainAppViewController?
    var exp: Int
    var health: Int {
        didSet {
            mainView?.controlView.reloadBatteryView()
        }
    }
    
    init() {
        self.exp = 0
        self.health = 3
    }
    
}
