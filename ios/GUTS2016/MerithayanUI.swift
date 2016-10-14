//
//  MerithayanUI.swift
//  Calendonia
//
//  Created by Tim Hull on 30/08/2016.
//  Copyright © 2016 Timothy Hull. All rights reserved.
//

import Foundation
import UIKit

struct MerithayanUI {
    
    //------------ Full Color Palette, based on colors from Material Design by Google
    
    // Colors with accents
    static let red = RedColor()
    static let pink = PinkColor()
    static let purple = PurpleColor()
    static let deepPurple = DeepPurpleColor()
    static let indigo = IndigoColor()
    static let blue = BlueColor()
    static let lightBlue = LightBlueColor()
    static let cyan = CyanColor()
    static let teal = TealColor()
    static let green = GreenColor()
    static let lightGreen = LightGreenColor()
    static let lime = LimeColor()
    static let yellow = YellowColor()
    static let amber = AmberColor()
    static let orange = OrangeColor()
    static let deepOrange = DeepOrangeColor()
    
    // Non-accented colors
    static let brown = BrownColor()
    static let grey = GreyColor()
    static let blueGrey = BlueGreyColor()
    
    // Black and white
    static let black = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
    static let white = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
    
}

protocol MerithayanColor {
    var lighten5: UIColor {get}
    var lighten4: UIColor {get}
    var lighten3: UIColor {get}
    var lighten2: UIColor {get}
    var lighten1: UIColor {get}
    
    var base: UIColor {get}
    
    var darken1: UIColor {get}
    var darken2: UIColor {get}
    var darken3: UIColor {get}
    var darken4: UIColor {get}
}

protocol MerithayanColorWithAccent: MerithayanColor {
    var accent1: UIColor {get}
    var accent2: UIColor {get}
    var accent3: UIColor {get}
    var accent4: UIColor {get}
}

struct RedColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:1.00, green:0.92, blue:0.93, alpha:1.0)
    let lighten4 = UIColor(red:1.00, green:0.80, blue:0.82, alpha:1.0)
    let lighten3 = UIColor(red:0.94, green:0.60, blue:0.60, alpha:1.0)
    let lighten2 = UIColor(red:0.90, green:0.45, blue:0.45, alpha:1.0)
    let lighten1 = UIColor(red:0.94, green:0.33, blue:0.31, alpha:1.0)
    
    let base = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
    
    let darken1 = UIColor(red:0.90, green:0.22, blue:0.21, alpha:1.0)
    let darken2 = UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)
    let darken3 = UIColor(red:0.78, green:0.16, blue:0.16, alpha:1.0)
    let darken4 = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0)
    
    let accent1 = UIColor(red:1.00, green:0.54, blue:0.50, alpha:1.0)
    let accent2 = UIColor(red:1.00, green:0.32, blue:0.32, alpha:1.0)
    let accent3 = UIColor(red:1.00, green:0.09, blue:0.27, alpha:1.0)
    let accent4 = UIColor(red:0.84, green:0.00, blue:0.00, alpha:1.0)
}

struct PinkColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.99, green:0.89, blue:0.93, alpha:1.0)
    let lighten4 = UIColor(red:0.97, green:0.73, blue:0.82, alpha:1.0)
    let lighten3 = UIColor(red:0.96, green:0.56, blue:0.69, alpha:1.0)
    let lighten2 = UIColor(red:0.94, green:0.38, blue:0.57, alpha:1.0)
    let lighten1 = UIColor(red:0.93, green:0.25, blue:0.48, alpha:1.0)
    
    let base = UIColor(red:0.91, green:0.12, blue:0.39, alpha:1.0)
    
    let darken1 = UIColor(red:0.85, green:0.11, blue:0.38, alpha:1.0)
    let darken2 = UIColor(red:0.76, green:0.09, blue:0.36, alpha:1.0)
    let darken3 = UIColor(red:0.68, green:0.08, blue:0.34, alpha:1.0)
    let darken4 = UIColor(red:0.53, green:0.05, blue:0.31, alpha:1.0)
    
    let accent1 = UIColor(red:1.00, green:0.50, blue:0.67, alpha:1.0)
    let accent2 = UIColor(red:1.00, green:0.25, blue:0.51, alpha:1.0)
    let accent3 = UIColor(red:0.96, green:0.00, blue:0.34, alpha:1.0)
    let accent4 = UIColor(red:0.77, green:0.07, blue:0.38, alpha:1.0)
}

struct PurpleColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.95, green:0.90, blue:0.96, alpha:1.0)
    let lighten4 = UIColor(red:0.88, green:0.75, blue:0.91, alpha:1.0)
    let lighten3 = UIColor(red:0.81, green:0.58, blue:0.85, alpha:1.0)
    let lighten2 = UIColor(red:0.73, green:0.41, blue:0.78, alpha:1.0)
    let lighten1 = UIColor(red:0.67, green:0.28, blue:0.74, alpha:1.0)
    
    let base = UIColor(red:0.61, green:0.15, blue:0.69, alpha:1.0)
    
    let darken1 = UIColor(red:0.56, green:0.14, blue:0.67, alpha:1.0)
    let darken2 = UIColor(red:0.48, green:0.12, blue:0.64, alpha:1.0)
    let darken3 = UIColor(red:0.42, green:0.11, blue:0.60, alpha:1.0)
    let darken4 = UIColor(red:0.29, green:0.08, blue:0.55, alpha:1.0)
    
    let accent1 = UIColor(red:0.92, green:0.50, blue:0.99, alpha:1.0)
    let accent2 = UIColor(red:0.88, green:0.25, blue:0.98, alpha:1.0)
    let accent3 = UIColor(red:0.84, green:0.00, blue:0.98, alpha:1.0)
    let accent4 = UIColor(red:0.67, green:0.00, blue:1.00, alpha:1.0)
    
}

struct DeepPurpleColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.93, green:0.91, blue:0.96, alpha:1.0)
    let lighten4 = UIColor(red:0.82, green:0.77, blue:0.91, alpha:1.0)
    let lighten3 = UIColor(red:0.70, green:0.62, blue:0.86, alpha:1.0)
    let lighten2 = UIColor(red:0.58, green:0.46, blue:0.80, alpha:1.0)
    let lighten1 = UIColor(red:0.49, green:0.34, blue:0.76, alpha:1.0)
    
    let base = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
    
    let darken1 = UIColor(red:0.37, green:0.21, blue:0.69, alpha:1.0)
    let darken2 = UIColor(red:0.32, green:0.18, blue:0.66, alpha:1.0)
    let darken3 = UIColor(red:0.27, green:0.15, blue:0.63, alpha:1.0)
    let darken4 = UIColor(red:0.19, green:0.11, blue:0.57, alpha:1.0)
    
    let accent1 = UIColor(red:0.70, green:0.53, blue:1.00, alpha:1.0)
    let accent2 = UIColor(red:0.49, green:0.30, blue:1.00, alpha:1.0)
    let accent3 = UIColor(red:0.40, green:0.12, blue:1.00, alpha:1.0)
    let accent4 = UIColor(red:0.38, green:0.00, blue:0.92, alpha:1.0)
}

struct IndigoColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.91, green:0.92, blue:0.96, alpha:1.0)
    let lighten4 = UIColor(red:0.77, green:0.79, blue:0.91, alpha:1.0)
    let lighten3 = UIColor(red:0.62, green:0.66, blue:0.85, alpha:1.0)
    let lighten2 = UIColor(red:0.47, green:0.53, blue:0.80, alpha:1.0)
    let lighten1 = UIColor(red:0.36, green:0.42, blue:0.75, alpha:1.0)
    
    let base = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
    
    let darken1 = UIColor(red:0.22, green:0.29, blue:0.67, alpha:1.0)
    let darken2 = UIColor(red:0.19, green:0.25, blue:0.62, alpha:1.0)
    let darken3 = UIColor(red:0.16, green:0.21, blue:0.58, alpha:1.0)
    let darken4 = UIColor(red:0.10, green:0.14, blue:0.49, alpha:1.0)
    
    let accent1 = UIColor(red:0.55, green:0.62, blue:1.00, alpha:1.0)
    let accent2 = UIColor(red:0.33, green:0.43, blue:1.00, alpha:1.0)
    let accent3 = UIColor(red:0.24, green:0.35, blue:1.00, alpha:1.0)
    let accent4 = UIColor(red:0.19, green:0.31, blue:1.00, alpha:1.0)
}

struct BlueColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.89, green:0.95, blue:0.99, alpha:1.0)
    let lighten4 = UIColor(red:0.73, green:0.87, blue:0.98, alpha:1.0)
    let lighten3 = UIColor(red:0.56, green:0.79, blue:0.98, alpha:1.0)
    let lighten2 = UIColor(red:0.39, green:0.71, blue:0.96, alpha:1.0)
    let lighten1 = UIColor(red:0.26, green:0.65, blue:0.96, alpha:1.0)
    
    let base = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
    
    let darken1 = UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0)
    let darken2 = UIColor(red:0.10, green:0.46, blue:0.82, alpha:1.0)
    let darken3 = UIColor(red:0.08, green:0.40, blue:0.75, alpha:1.0)
    let darken4 = UIColor(red:0.05, green:0.28, blue:0.63, alpha:1.0)
    
    let accent1 = UIColor(red:0.51, green:0.69, blue:1.00, alpha:1.0)
    let accent2 = UIColor(red:0.27, green:0.54, blue:1.00, alpha:1.0)
    let accent3 = UIColor(red:0.16, green:0.47, blue:1.00, alpha:1.0)
    let accent4 = UIColor(red:0.16, green:0.38, blue:1.00, alpha:1.0)
}

struct LightBlueColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.88, green:0.96, blue:1.00, alpha:1.0)
    let lighten4 = UIColor(red:0.70, green:0.90, blue:0.99, alpha:1.0)
    let lighten3 = UIColor(red:0.51, green:0.83, blue:0.98, alpha:1.0)
    let lighten2 = UIColor(red:0.31, green:0.76, blue:0.97, alpha:1.0)
    let lighten1 = UIColor(red:0.16, green:0.71, blue:0.96, alpha:1.0)
    
    let base = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1.0)
    
    let darken1 = UIColor(red:0.01, green:0.61, blue:0.90, alpha:1.0)
    let darken2 = UIColor(red:0.01, green:0.53, blue:0.82, alpha:1.0)
    let darken3 = UIColor(red:0.01, green:0.47, blue:0.74, alpha:1.0)
    let darken4 = UIColor(red:0.00, green:0.34, blue:0.61, alpha:1.0)
    
    let accent1 = UIColor(red:0.50, green:0.85, blue:1.00, alpha:1.0)
    let accent2 = UIColor(red:0.25, green:0.77, blue:1.00, alpha:1.0)
    let accent3 = UIColor(red:0.00, green:0.69, blue:1.00, alpha:1.0)
    let accent4 = UIColor(red:0.00, green:0.57, blue:0.92, alpha:1.0)
}

struct CyanColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.88, green:0.97, blue:0.98, alpha:1.0)
    let lighten4 = UIColor(red:0.70, green:0.92, blue:0.95, alpha:1.0)
    let lighten3 = UIColor(red:0.50, green:0.87, blue:0.92, alpha:1.0)
    let lighten2 = UIColor(red:0.30, green:0.82, blue:0.88, alpha:1.0)
    let lighten1 = UIColor(red:0.15, green:0.78, blue:0.85, alpha:1.0)
    
    let base = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
    
    let darken1 = UIColor(red:0.00, green:0.67, blue:0.76, alpha:1.0)
    let darken2 = UIColor(red:0.00, green:0.59, blue:0.65, alpha:1.0)
    let darken3 = UIColor(red:0.00, green:0.51, blue:0.56, alpha:1.0)
    let darken4 = UIColor(red:0.00, green:0.38, blue:0.39, alpha:1.0)
    
    let accent1 = UIColor(red:0.52, green:1.00, blue:1.00, alpha:1.0)
    let accent2 = UIColor(red:0.09, green:1.00, blue:1.00, alpha:1.0)
    let accent3 = UIColor(red:0.00, green:0.90, blue:1.00, alpha:1.0)
    let accent4 = UIColor(red:0.00, green:0.72, blue:0.83, alpha:1.0)
}

struct TealColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.88, green:0.95, blue:0.95, alpha:1.0)
    let lighten4 = UIColor(red:0.70, green:0.87, blue:0.86, alpha:1.0)
    let lighten3 = UIColor(red:0.50, green:0.80, blue:0.77, alpha:1.0)
    let lighten2 = UIColor(red:0.30, green:0.71, blue:0.67, alpha:1.0)
    let lighten1 = UIColor(red:0.15, green:0.65, blue:0.60, alpha:1.0)
    
    let base = UIColor(red:0.00, green:0.59, blue:0.53, alpha:1.0)
    
    let darken1 = UIColor(red:0.00, green:0.54, blue:0.48, alpha:1.0)
    let darken2 = UIColor(red:0.00, green:0.47, blue:0.42, alpha:1.0)
    let darken3 = UIColor(red:0.00, green:0.41, blue:0.36, alpha:1.0)
    let darken4 = UIColor(red:0.00, green:0.30, blue:0.25, alpha:1.0)
    
    let accent1 = UIColor(red:0.65, green:1.00, blue:0.92, alpha:1.0)
    let accent2 = UIColor(red:0.39, green:1.00, blue:0.85, alpha:1.0)
    let accent3 = UIColor(red:0.11, green:0.91, blue:0.71, alpha:1.0)
    let accent4 = UIColor(red:0.00, green:0.75, blue:0.65, alpha:1.0)
    
}

struct GreenColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.91, green:0.96, blue:0.91, alpha:1.0)
    let lighten4 = UIColor(red:0.78, green:0.90, blue:0.79, alpha:1.0)
    let lighten3 = UIColor(red:0.65, green:0.84, blue:0.65, alpha:1.0)
    let lighten2 = UIColor(red:0.51, green:0.78, blue:0.52, alpha:1.0)
    let lighten1 = UIColor(red:0.40, green:0.73, blue:0.42, alpha:1.0)
    
    let base = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
    
    let darken1 = UIColor(red:0.26, green:0.63, blue:0.28, alpha:1.0)
    let darken2 = UIColor(red:0.22, green:0.56, blue:0.24, alpha:1.0)
    let darken3 = UIColor(red:0.18, green:0.49, blue:0.20, alpha:1.0)
    let darken4 = UIColor(red:0.11, green:0.37, blue:0.13, alpha:1.0)
    
    let accent1 = UIColor(red:0.73, green:0.96, blue:0.79, alpha:1.0)
    let accent2 = UIColor(red:0.41, green:0.94, blue:0.68, alpha:1.0)
    let accent3 = UIColor(red:0.00, green:0.90, blue:0.46, alpha:1.0)
    let accent4 = UIColor(red:0.00, green:0.78, blue:0.33, alpha:1.0)
}

struct LightGreenColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.95, green:0.97, blue:0.91, alpha:1.0)
    let lighten4 = UIColor(red:0.86, green:0.93, blue:0.78, alpha:1.0)
    let lighten3 = UIColor(red:0.77, green:0.88, blue:0.65, alpha:1.0)
    let lighten2 = UIColor(red:0.68, green:0.84, blue:0.51, alpha:1.0)
    let lighten1 = UIColor(red:0.61, green:0.80, blue:0.40, alpha:1.0)
    
    let base = UIColor(red:0.55, green:0.76, blue:0.29, alpha:1.0)
    
    let darken1 = UIColor(red:0.49, green:0.70, blue:0.26, alpha:1.0)
    let darken2 = UIColor(red:0.41, green:0.62, blue:0.22, alpha:1.0)
    let darken3 = UIColor(red:0.33, green:0.55, blue:0.18, alpha:1.0)
    let darken4 = UIColor(red:0.20, green:0.41, blue:0.12, alpha:1.0)
    
    let accent1 = UIColor(red:0.80, green:1.00, blue:0.56, alpha:1.0)
    let accent2 = UIColor(red:0.70, green:1.00, blue:0.35, alpha:1.0)
    let accent3 = UIColor(red:0.46, green:1.00, blue:0.01, alpha:1.0)
    let accent4 = UIColor(red:0.39, green:0.87, blue:0.09, alpha:1.0)
}

struct LimeColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.98, green:0.98, blue:0.91, alpha:1.0)
    let lighten4 = UIColor(red:0.94, green:0.96, blue:0.76, alpha:1.0)
    let lighten3 = UIColor(red:0.90, green:0.93, blue:0.61, alpha:1.0)
    let lighten2 = UIColor(red:0.86, green:0.91, blue:0.46, alpha:1.0)
    let lighten1 = UIColor(red:0.83, green:0.88, blue:0.34, alpha:1.0)
    
    let base = UIColor(red:0.80, green:0.86, blue:0.22, alpha:1.0)
    
    let darken1 = UIColor(red:0.75, green:0.79, blue:0.20, alpha:1.0)
    let darken2 = UIColor(red:0.69, green:0.71, blue:0.17, alpha:1.0)
    let darken3 = UIColor(red:0.62, green:0.62, blue:0.14, alpha:1.0)
    let darken4 = UIColor(red:0.51, green:0.47, blue:0.09, alpha:1.0)
    
    let accent1 = UIColor(red:0.96, green:1.00, blue:0.51, alpha:1.0)
    let accent2 = UIColor(red:0.93, green:1.00, blue:0.25, alpha:1.0)
    let accent3 = UIColor(red:0.78, green:1.00, blue:0.00, alpha:1.0)
    let accent4 = UIColor(red:0.68, green:0.92, blue:0.00, alpha:1.0)
}

struct YellowColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:1.00, green:0.99, blue:0.91, alpha:1.0)
    let lighten4 = UIColor(red:1.00, green:0.98, blue:0.77, alpha:1.0)
    let lighten3 = UIColor(red:1.00, green:0.96, blue:0.62, alpha:1.0)
    let lighten2 = UIColor(red:1.00, green:0.95, blue:0.46, alpha:1.0)
    let lighten1 = UIColor(red:1.00, green:0.93, blue:0.35, alpha:1.0)
    
    let base = UIColor(red:1.00, green:0.92, blue:0.23, alpha:1.0)
    
    let darken1 = UIColor(red:0.99, green:0.85, blue:0.21, alpha:1.0)
    let darken2 = UIColor(red:0.98, green:0.75, blue:0.18, alpha:1.0)
    let darken3 = UIColor(red:0.98, green:0.66, blue:0.15, alpha:1.0)
    let darken4 = UIColor(red:0.96, green:0.50, blue:0.09, alpha:1.0)
    
    let accent1 = UIColor(red:1.00, green:1.00, blue:0.55, alpha:1.0)
    let accent2 = UIColor(red:1.00, green:1.00, blue:0.00, alpha:1.0)
    let accent3 = UIColor(red:1.00, green:0.92, blue:0.00, alpha:1.0)
    let accent4 = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
}

struct AmberColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:1.00, green:0.97, blue:0.88, alpha:1.0)
    let lighten4 = UIColor(red:1.00, green:0.93, blue:0.70, alpha:1.0)
    let lighten3 = UIColor(red:1.00, green:0.88, blue:0.51, alpha:1.0)
    let lighten2 = UIColor(red:1.00, green:0.84, blue:0.31, alpha:1.0)
    let lighten1 = UIColor(red:1.00, green:0.79, blue:0.16, alpha:1.0)
    
    let base = UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0)
    
    let darken1 = UIColor(red:1.00, green:0.70, blue:0.00, alpha:1.0)
    let darken2 = UIColor(red:1.00, green:0.63, blue:0.00, alpha:1.0)
    let darken3 = UIColor(red:1.00, green:0.56, blue:0.00, alpha:1.0)
    let darken4 = UIColor(red:1.00, green:0.44, blue:0.00, alpha:1.0)
    
    let accent1 = UIColor(red:1.00, green:0.90, blue:0.50, alpha:1.0)
    let accent2 = UIColor(red:1.00, green:0.84, blue:0.25, alpha:1.0)
    let accent3 = UIColor(red:1.00, green:0.77, blue:0.00, alpha:1.0)
    let accent4 = UIColor(red:1.00, green:0.67, blue:0.00, alpha:1.0)
}

struct OrangeColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:1.00, green:0.95, blue:0.88, alpha:1.0)
    let lighten4 = UIColor(red:1.00, green:0.88, blue:0.70, alpha:1.0)
    let lighten3 = UIColor(red:1.00, green:0.80, blue:0.50, alpha:1.0)
    let lighten2 = UIColor(red:1.00, green:0.72, blue:0.30, alpha:1.0)
    let lighten1 = UIColor(red:1.00, green:0.65, blue:0.15, alpha:1.0)
    
    let base = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
    
    let darken1 = UIColor(red:0.98, green:0.55, blue:0.00, alpha:1.0)
    let darken2 = UIColor(red:0.96, green:0.49, blue:0.00, alpha:1.0)
    let darken3 = UIColor(red:0.94, green:0.42, blue:0.00, alpha:1.0)
    let darken4 = UIColor(red:0.90, green:0.32, blue:0.00, alpha:1.0)
    
    let accent1 = UIColor(red:1.00, green:0.82, blue:0.50, alpha:1.0)
    let accent2 = UIColor(red:1.00, green:0.67, blue:0.25, alpha:1.0)
    let accent3 = UIColor(red:1.00, green:0.57, blue:0.00, alpha:1.0)
    let accent4 = UIColor(red:1.00, green:0.43, blue:0.00, alpha:1.0)
}

struct DeepOrangeColor: MerithayanColorWithAccent {
    let lighten5 = UIColor(red:0.98, green:0.91, blue:0.91, alpha:1.0)
    let lighten4 = UIColor(red:1.00, green:0.80, blue:0.74, alpha:1.0)
    let lighten3 = UIColor(red:1.00, green:0.67, blue:0.57, alpha:1.0)
    let lighten2 = UIColor(red:1.00, green:0.54, blue:0.40, alpha:1.0)
    let lighten1 = UIColor(red:1.00, green:0.44, blue:0.26, alpha:1.0)
    
    let base = UIColor(red:1.00, green:0.34, blue:0.13, alpha:1.0)
    
    let darken1 = UIColor(red:0.96, green:0.32, blue:0.12, alpha:1.0)
    let darken2 = UIColor(red:0.90, green:0.29, blue:0.10, alpha:1.0)
    let darken3 = UIColor(red:0.85, green:0.26, blue:0.08, alpha:1.0)
    let darken4 = UIColor(red:0.75, green:0.21, blue:0.05, alpha:1.0)
    
    let accent1 = UIColor(red:1.00, green:0.62, blue:0.50, alpha:1.0)
    let accent2 = UIColor(red:1.00, green:0.43, blue:0.25, alpha:1.0)
    let accent3 = UIColor(red:1.00, green:0.24, blue:0.00, alpha:1.0)
    let accent4 = UIColor(red:0.87, green:0.17, blue:0.00, alpha:1.0)
}
// ***********************************************************
// MERITHAYAN COLORS WITHOUT ACCENTS
// ***********************************************************
// These colors have no accents so can't be used as Merithayan Colors with Accents, but are useful in other situations



struct BrownColor: MerithayanColor {
    let lighten5 = UIColor(red:0.94, green:0.92, blue:0.91, alpha:1.0)
    let lighten4 = UIColor(red:0.84, green:0.80, blue:0.78, alpha:1.0)
    let lighten3 = UIColor(red:0.74, green:0.67, blue:0.64, alpha:1.0)
    let lighten2 = UIColor(red:0.63, green:0.53, blue:0.50, alpha:1.0)
    let lighten1 = UIColor(red:0.55, green:0.43, blue:0.39, alpha:1.0)
    
    let base = UIColor(red:0.47, green:0.33, blue:0.28, alpha:1.0)
    
    let darken1 = UIColor(red:0.43, green:0.30, blue:0.25, alpha:1.0)
    let darken2 = UIColor(red:0.36, green:0.25, blue:0.22, alpha:1.0)
    let darken3 = UIColor(red:0.31, green:0.20, blue:0.18, alpha:1.0)
    let darken4 = UIColor(red:0.24, green:0.15, blue:0.14, alpha:1.0)
}

struct BlueGreyColor: MerithayanColor {
    let lighten5 = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
    let lighten4 = UIColor(red:0.81, green:0.85, blue:0.86, alpha:1.0)
    let lighten3 = UIColor(red:0.69, green:0.75, blue:0.77, alpha:1.0)
    let lighten2 = UIColor(red:0.56, green:0.64, blue:0.68, alpha:1.0)
    let lighten1 = UIColor(red:0.47, green:0.56, blue:0.61, alpha:1.0)
    
    let base = UIColor(red:0.38, green:0.49, blue:0.55, alpha:1.0)
    
    let darken1 = UIColor(red:0.33, green:0.43, blue:0.48, alpha:1.0)
    let darken2 = UIColor(red:0.27, green:0.35, blue:0.39, alpha:1.0)
    let darken3 = UIColor(red:0.22, green:0.28, blue:0.31, alpha:1.0)
    let darken4 = UIColor(red:0.15, green:0.20, blue:0.22, alpha:1.0)
}

struct GreyColor: MerithayanColor {
    let lighten5 = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    let lighten4 = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    let lighten3 = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
    let lighten2 = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
    let lighten1 = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
    
    let base = UIColor(red:0.62, green:0.62, blue:0.62, alpha:1.0)
    
    let darken1 = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)
    let darken2 = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
    let darken3 = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
    let darken4 = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
}
