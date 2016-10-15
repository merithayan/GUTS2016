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

var username: String = ""

class UserSetupViewController: UIViewController {
    
    let usernameEntryField = UITextField()
    let viewTitle = UILabel()
    let confirmButton = UIButton()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewColor = MerithayanUI.blueGrey
        view.backgroundColor = viewColor.darken2
        
        // Setup the username entry field
        usernameEntryField.translatesAutoresizingMaskIntoConstraints = false // Needed for programmatic layout to work properly
        usernameEntryField.autocorrectionType = .no
        usernameEntryField.autocapitalizationType = .none
        usernameEntryField.backgroundColor = viewColor.base
        usernameEntryField.drawText(in: CGRect(x: 5.0, y: 0, width: usernameEntryField.bounds.width-5.0, height: usernameEntryField.bounds.height))
        usernameEntryField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
            
        // Setup the title
        viewTitle.text = "Enter a username"
        viewTitle.textAlignment = .center
        viewTitle.font = UIFont.monospacedDigitSystemFont(ofSize: 20.0, weight: 1.0)
        viewTitle.textColor = MerithayanUI.lightGreen.base
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
    
        // Setup the confirm button
        confirmButton.setTitle("Go!", for: .normal)
        confirmButton.setTitleColor(MerithayanUI.lightGreen.base, for: .normal)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        
        // Layout the view ready for use
        view.addSubview(usernameEntryField)
        view.addSubview(viewTitle)
        view.addSubview(confirmButton)
        
        // Add the layout constraints (horizontal)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":usernameEntryField]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewTitle]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":confirmButton]))
        
        // Add the vertical layout constraints
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[v0]-20-[v1(>=50)]-20-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":viewTitle, "v1": usernameEntryField, "v2": confirmButton]))
    }
    
    func confirmAction(){
        // The action fired when the confirm button is pressed.
        username = usernameEntryField.text!
        present(MainAppViewController(), animated: true, completion: nil)
    }
}
