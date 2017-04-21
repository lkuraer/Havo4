//
//  Colors.swift
//  Havo4
//
//  Created by Ruslan Sabirov on 3/27/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    fileprivate var _temp: Int!
    
    var temp: Int! {
        return _temp
    }
    
    init(temp: Int) {
        self._temp = temp
    }
    
    func colorifyBG() -> UIColor {
        switch temp {
        case -60...(-36):
            return UIColor(red:0, green:0.22, blue:0.56, alpha:1)
        case -35...(-31):
            return UIColor(red:0.03, green:0.27, blue:0.61, alpha:1)
        case -30...(-26):
            return UIColor(red:0.13, green:0.39, blue:0.67, alpha:1)
        case -25...(-21):
            return UIColor(red:0.22, green:0.49, blue:0.72, alpha:1)
        case -20...(-17):
            return UIColor(red:0.3, green:0.6, blue:0.77, alpha:1)
        case -16...(-14):
            return UIColor(red:0.4, green:0.72, blue:0.83, alpha:1)
        case -13...(-10):
            return UIColor(red:0.45, green:0.82, blue:0.84, alpha:1)
        case -9...(-5):
            return UIColor(red:0.47, green:0.85, blue:0.82, alpha:1)
        case -4...0:
            return UIColor(red:0.46, green:0.92, blue:0.86, alpha:1)
        case 1...4:
            return UIColor(red:1.00, green:0.80, blue:0.40, alpha:1.00)
        case 5...9:
            return UIColor(red:0.99, green:0.75, blue:0.36, alpha:1.00)
        case 10...13:
            return UIColor(red:0.98, green:0.68, blue:0.32, alpha:1.00)
        case 14...16:
            return UIColor(red:0.97, green:0.62, blue:0.28, alpha:1.00)
        case 17...20:
            return UIColor(red:0.96, green:0.55, blue:0.24, alpha:1.00)
        case 21...25:
            return UIColor(red:0.95, green:0.47, blue:0.20, alpha:1.00)
        case 26...30:
            return UIColor(red:0.93, green:0.40, blue:0.15, alpha:1.00)
        case 31...35:
            return UIColor(red:0.93, green:0.35, blue:0.11, alpha:1.00)
        case 36...60:
            return UIColor(red:0.91, green:0.26, blue:0.06, alpha:1.00)
        default: return UIColor(red:0.93, green:0.93, blue:0.93, alpha:1)
        }
    }
}
