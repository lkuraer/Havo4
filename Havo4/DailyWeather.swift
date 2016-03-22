//
//  DailyWeather.swift
//  Havo2
//
//  Created by Ruslan Sabirov on 3/4/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import Foundation

//
//  DailyWeather.swift
//  havo
//
//  Created by Ruslan Sabirov on 3/1/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import Foundation
import UIKit

struct DailyWeather {
    private var _minTemperature: Int!
    private var _maxTemperature: Int!
    private var _icon: String!
    private var _sunrise: String!
    private var _sunset: String!
    private var _windSpeed: Int!
    private var _humidity: Double!
    private var _pressure: Int!
    private var _day: String!
    private var _date: String!
    private var _summary: String!
    private var _color: UIColor!
    let dateFormatter = NSDateFormatter()
    
    var color: UIColor {
        return _color
    }
    
    var summary: String {
        return _summary
    }
    
    var day: String  {
        return _day
    }
    
    var date: String {
        return _date
    }
    
    var minTemperature: Int {
        return _minTemperature
    }
    
    var maxTemperature: Int {
        return _maxTemperature
    }
    
    var icon: String {
        return _icon
    }
    
    var sunrise: String {
        return _sunrise
    }
    
    var sunset: String {
        return _sunset
    }
    
    var windSpeed: Int {
        return _windSpeed
    }
    
    var humidity: Double {
        return _humidity
    }
    
    var pressure: Int {
        return _pressure
    }
    
    init(dailyWeatherDict: [String: AnyObject]) {
        if let minTemp = dailyWeatherDict["temperatureMin"] as? Int {
            self._minTemperature = minTemp
        }
        
        if let maxTemp = dailyWeatherDict["temperatureMax"] as? Int {
            self._maxTemperature = maxTemp
        }
        
        if let iconImage = dailyWeatherDict["icon"] as? String,
            let weatherIcon: WeatherIcons = WeatherIcons(rawValue: iconImage) {
            self._icon = weatherIcon.toIcon()
        }
        
        if let sunriseTime = dailyWeatherDict["sunriseTime"] as? Double {
            self._sunrise = timeStringFromUnix(sunriseTime)
        }
        
        if let sunsetTime = dailyWeatherDict["sunsetTime"] as? Double {
            self._sunset = timeStringFromUnix(sunsetTime)
        }
        
        if let wind = dailyWeatherDict["windSpeed"] as? Int {
            self._windSpeed = wind
        }
        
        if let humidityDouble = dailyWeatherDict["humidity"] as? Double {
            self._humidity = humidityDouble
        }
        
        if let pressureDouble = dailyWeatherDict["pressure"] as? Int {
            self._pressure = pressureDouble
        }
        
        if let day = dailyWeatherDict["time"] as? Double {
            let gotDay = dayStringFromUnix(day)
            if let days: WeekDays = WeekDays(rawValue: gotDay) {
                self._day = days.toRus()
            }
        }
        
        if let date = dailyWeatherDict["time"] as? Double {
            self._date = dateStringFromUnix(date)
        }
        
        if let summary = dailyWeatherDict["summary"] as? String {
            self._summary = summary
        }
        
        if let color = dailyWeatherDict["temperatureMax"] as? Int {
            self._color = colorifyBG(color)
        }
    }
    
    func timeStringFromUnix(UnixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: UnixTime)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    func dayStringFromUnix(time: Double) -> String {
        let date = NSDate(timeIntervalSince1970: time)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
    
    func dateStringFromUnix(date: Double) -> String {
        let date = NSDate(timeIntervalSince1970: date)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.stringFromDate(date)
    }
    
    func colorifyBG(temperature: Int) -> UIColor {
        switch temperature {
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
        case 25...60:
            return UIColor(red:0.82, green:0.1, blue:0.1, alpha:1)
        default: return UIColor(red:0.84, green:0.84, blue:0.84, alpha:1)
        }
    }
    
}

