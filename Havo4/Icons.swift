//
//  Icons.swift
//  Havo4
//
//  Created by Ruslan Sabirov on 3/27/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import Foundation

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
