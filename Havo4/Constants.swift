//
//  Constants.swift
//  Havo2
//
//  Created by Ruslan Sabirov on 3/2/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import Foundation
import UIKit

let BASE_URL = "https://api.forecast.io/forecast/"
let API_KEY = "f408268dbd1a091c36d503d0d822b834"

typealias DownloadCoplete = () -> ()

enum WeatherIcons: String {
    case ClearDay = "clear-day"
    case ClearNight = "clear-night"
    case Rain = "rain"
    case Snow = "snow"
    case Sleet = "sleet"
    case Wind = "wind"
    case Fog = "fog"
    case Cloudly = "cloudy"
    case PartlyCloudlyDay = "partly-cloudy-day"
    case PartlyCloudlyNight = "partly-cloudy-night"
    case Tornado = "tornado"
    
    func toIcon() -> String {
        var iconName: String
        
        switch self {
        case.ClearDay:
            iconName = "\u{f00d}"
        case.ClearNight:
            iconName = "\u{f02e}"
        case.Rain:
            iconName = "\u{f019}"
        case.Snow:
            iconName = "\u{f01b}"
        case.Sleet:
            iconName = "\u{f0b5}"
        case.Wind:
            iconName = "\u{f021}"
        case.Fog:
            iconName = "\u{f014}"
        case.Cloudly:
            iconName = "\u{f013}"
        case.PartlyCloudlyDay:
            iconName = "\u{f002}"
        case.PartlyCloudlyNight:
            iconName = "\u{f086}"
        case.Tornado:
            iconName = "\u{f056}"
        }
        
        return iconName
    }
}

enum WeekDays: String {
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wedensday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    case Sunday = "Sunday"
    
    func toRus() -> String {
        var dayName: String
        
        switch self {
        case.Monday:
            dayName = "Понедельник"
        case.Tuesday:
            dayName = "Вторник"
        case.Wedensday:
            dayName = "Среда"
        case.Thursday:
            dayName = "Четверг"
        case.Friday:
            dayName = "Пятница"
        case.Saturday:
            dayName = "Суббота"
        case.Sunday:
            dayName = "Воскресенье"
        }
        
        return dayName
    }
}

struct Colors {
    private var _temp: Int!
    
    var temp: Int! {
        return _temp
    }
    
    init(temp: Int) {
        self._temp = temp
    }
    
    func colorifyBG() -> UIColor {
        switch temp {
        case -60...(-21):
            return UIColor(red:0.16, green:0.51, blue:0.62, alpha:1)
        case -20...(-11):
            return UIColor(red:0.27, green:0.7, blue:0.84, alpha:1)
        case -10...(-4):
            return UIColor(red:0.49, green:0.83, blue:0.93, alpha:1)
        case -3...0:
            return UIColor(red:0.6, green:0.91, blue:1, alpha:1)
        case 1...4:
            return UIColor(red:0.12, green:0.69, blue:0.64, alpha:1)
        case 5...9:
            return UIColor(red:0.01, green:0.73, blue:0.67, alpha:1)
        case 10...13:
            return UIColor(red:0.32, green:0.82, blue:0.78, alpha:1)
        case 14...16:
            return UIColor(red:0.52, green:0.87, blue:0.84, alpha:1)
        case 17...21:
            return UIColor(red:1, green:0.81, blue:0.41, alpha:1)
        case 21...25:
            return UIColor(red:1, green:0.75, blue:0.2, alpha:1)
        case 26...30:
            return UIColor(red:0.94, green:0.69, blue:0.17, alpha:1)
        case 31...35:
            return UIColor(red:1, green:0.35, blue:0, alpha:1)
        case 36...60:
            return UIColor(red:0.82, green:0.1, blue:0.1, alpha:1)
        default: return UIColor(red:0.84, green:0.84, blue:0.84, alpha:1)
        }
    }
}
