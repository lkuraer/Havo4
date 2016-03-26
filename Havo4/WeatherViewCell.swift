//
//  WeatherViewCell.swift
//  Havo4
//
//  Created by Ruslan Sabirov on 3/22/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import UIKit

class WeatherViewCell: UITableViewCell {
    
    @IBOutlet weak var dailyTemp: UILabel!
    @IBOutlet weak var dailyIcon: UILabel!
    @IBOutlet weak var dailySummary: UILabel!
    @IBOutlet weak var dailyDate: UILabel!
    
    var weeklyWeath: DailyWeather!
    var gradientLayer: CAGradientLayer!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGradient(self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(daily: DailyWeather, lang: String) {
        
        self.weeklyWeath = daily
//        var day: String!
        
//        if lang == "en_US" {
//            let gotDay = self.weeklyWeath.day
//            if let days: WeekDays = WeekDays(rawValue: gotDay) {
//                day = days.toRus()
//            }
//        } else {
//            day = "хуй"
//        }
//        
////        var day: String! {
////            if lang == "en_US"  {
////                let gotDay = self.weeklyWeath.day
////                var newDay: String!
////                if let days: WeekDays = WeekDays(rawValue: gotDay) {
////                    newDay = days.toRus()
////                }
////                return newDay
////            } else {
////               day = "хуй" 
////            }
////        }
        
        dailyTemp.text = "+\(self.weeklyWeath.maxTemperature)°"
        dailyIcon.text = self.weeklyWeath.icon
        dailyDate.text = "\(self.weeklyWeath.day) \(self.weeklyWeath.date)"
        dailySummary.text = self.weeklyWeath.summary
        contentView.backgroundColor = self.weeklyWeath.color
        
    }

    func addGradient(view: UIView) {
        if gradientLayer != nil {
            return
        } else {
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.frame
            let color1 = UIColor(red:0, green:0, blue:0, alpha:0).CGColor as CGColorRef
            let color2 = UIColor(red:0, green:0, blue:0, alpha:0.05).CGColor as CGColorRef
            gradientLayer.colors = [color1, color2]
            gradientLayer.locations = [0.0, 1.0]
            view.layer.insertSublayer(self.gradientLayer, atIndex: UInt32(1))
        }
    }


}
