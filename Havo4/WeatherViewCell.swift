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
    @IBOutlet weak var dailyDay: UILabel!
    
    var weeklyWeath: DailyWeather!
    var gradientLayer: CAGradientLayer!
    
    let pre = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGradient(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(daily: DailyWeather, index: Int) {
        
        self.weeklyWeath = daily
        
        var todayLabel: String {
            if pre == "ru" {
                return("Завтра")
            } else {
                return("Tomorrow")
            }
        }

        if index == 0 {
            dailyTemp.text = "\(self.weeklyWeath.maxTemperature)°"
            dailyIcon.text = self.weeklyWeath.icon
            dailyDay.text = "\(todayLabel)"
            dailySummary.text = self.weeklyWeath.summary
            dailyDate.text = ""
            contentView.backgroundColor = self.weeklyWeath.color
        } else {
            dailyTemp.text = "\(self.weeklyWeath.maxTemperature)°"
            dailyIcon.text = self.weeklyWeath.icon
            dailyDate.text = "\(self.weeklyWeath.date)"
            dailyDay.text = "\(self.weeklyWeath.day.capitalized)"
            dailySummary.text = self.weeklyWeath.summary
            contentView.backgroundColor = self.weeklyWeath.color
        }
        
    }

    func addGradient(_ view: UIView) {
        if gradientLayer != nil {
            return
        } else {
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.frame
            let color1 = UIColor(red:1, green:1, blue:1, alpha:0.07).cgColor as CGColor
            let color2 = UIColor(red:1, green:1, blue:1, alpha:0).cgColor as CGColor
            gradientLayer.colors = [color1, color2]
            gradientLayer.locations = [0.0, 1.0]
            view.layer.insertSublayer(self.gradientLayer, at: UInt32(1))
        }
    }


}
