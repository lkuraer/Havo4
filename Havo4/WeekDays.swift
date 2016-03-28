//
//  WeekDays.swift
//  Havo4
//
//  Created by Ruslan Sabirov on 3/27/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import Foundation

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
