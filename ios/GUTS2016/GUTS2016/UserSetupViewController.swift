//
//  UserSetupViewController.swift
//  GUTS2016
//
//  This file contains the user setup view controller and associated classes
//
//  Created by Tim Hull on 14/10/2016.
//  Copyright © 2016 Tim Hull. All rights reserved.
//

import Foundation
import UIKit

class UserSetupViewController: UIViewController {
    let usernameEntryField = UITextField()
    let viewTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout the view ready for use
        let viewColor = MerithayanUI.blueGrey
        view.backgroundColor = viewColor.darken2
        
        
        
    }
}
