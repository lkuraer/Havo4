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
    fileprivate var _minTemperature: Int!
    fileprivate var _maxTemperature: Int!
    fileprivate var _icon: String!
    fileprivate var _sunrise: String!
    fileprivate var _sunset: String!
    fileprivate var _windSpeed: Int!
    fileprivate var _humidity: Double!
    fileprivate var _pressure: Int!
    fileprivate var _day: String!
    fileprivate var _date: String!
    fileprivate var _summary: String!
    fileprivate var _color: UIColor!
    let dateFormatter = DateFormatter()
    
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
            self._day = dayStringFromUnix(day)
        }
        
        if let date = dailyWeatherDict["time"] as? Double {
            self._date = dateStringFromUnix(date)
        }
        
        if let summary = dailyWeatherDict["summary"] as? String {
            self._summary = summary
        }
        
        if let temp = dailyWeatherDict["temperatureMax"] as? Int {
            let gettingColor: Colors = Colors(temp: temp)
            self._color = gettingColor.colorifyBG()
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
        dateFormatter.dateFormat = "EEEEEE"
        return dateFormatter.string(from: date)
    }
    
    func dateStringFromUnix(_ date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: date)
    }
    
}

