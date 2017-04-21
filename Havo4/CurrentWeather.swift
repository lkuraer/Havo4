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
    fileprivate var _temperature: Int!
    fileprivate var _time: String!
    fileprivate var _color: UIColor!
    fileprivate var _day: String!
    
    let dateFormatter = DateFormatter()
    
    var color: UIColor {
        return _color
    }
    
    var temperature: Int {
        return _temperature
    }
    
    var time: String {
        return _time
    }
    
    var day: String {
        return _day
    }
    
    init(weatherDictionary: [String: AnyObject]) {
        if let temperature = weatherDictionary["temperature"] as? Int {
            self._temperature = temperature
        }
        
        if let time = weatherDictionary["time"] as? Double {
            self._time = timeStringFromUnix(time)
        }
        
        if let temp = weatherDictionary["temperature"] as? Int {
            let gettingColor: Colors = Colors(temp: temp)
            self._color = gettingColor.colorifyBG()
        }
        
        if let day = weatherDictionary["time"] as? Double {
            self._day = dayStringFromUnix(day)
        }
    }
    
    func timeStringFromUnix(_ UnixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: UnixTime)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func dayStringFromUnix(_ time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
        
}
