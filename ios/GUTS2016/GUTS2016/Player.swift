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
    var hasEmp = true {
        didSet {
            print("The hasEMP player value changed to:", hasEmp)
            if hasEmp {
                print("The value of hasEmp has been updated to true")
                mainView?.controlView.reactivateEmp()
            } else {
                mainView?.controlView.deactivateEmp()
            }
    
        }
    }

    var isEmpd = false

    var health: Int {
        didSet {
            mainView?.controlView.reloadBatteryView()
        }
    }
    
    init() {
        self.exp = 0
        self.health = 9
    }
    
    func timeOut() {
        mainView?.gameOver()
    }
    
    
}
