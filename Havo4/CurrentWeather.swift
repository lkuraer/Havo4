//
//  currentWeather.swift
//  Havo2
//
//  Created by Ruslan Sabirov on 3/4/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
    private var _temperature: Int!
    private var _time: String!
    private var _color: UIColor!
    let dateFormatter = NSDateFormatter()
    
    var color: UIColor {
        return _color
    }
    
    var temperature: Int {
        return _temperature
    }
    
    var time: String {
        return _time
    }
    
    init(weatherDictionary: [String: AnyObject]) {
        if let temperature = weatherDictionary["temperature"] as? Int {
            self._temperature = temperature
        }
        
        if let time = weatherDictionary["time"] as? Double {
            self._time = timeStringFromUnix(time)
        }
        
        if let color = weatherDictionary["temperature"] as? Int {
            self._color = colorifyBG(color)
        }
    }
    
    func timeStringFromUnix(UnixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: UnixTime)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    func colorifyBG(temperature: Int) -> UIColor {
        switch temperature {
        case -60..<15:
            return UIColor(red:0.3, green:0.81, blue:0.77, alpha:1)
        case 16...60:
            return UIColor(red:1, green:0.81, blue:0.41, alpha:1)
        default: return UIColor(red:0.84, green:0.84, blue:0.84, alpha:1)
        }
    }
    
    
    
}
