//
//  ViewController.swift
//  Havo4
//
//  Created by Ruslan Sabirov on 3/22/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityBackground: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentIcon: UILabel!
    @IBOutlet weak var currentDescription: UILabel!
    @IBOutlet weak var currentDayDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    var weatherDict: [String: AnyObject]!
    var currentDict: CurrentWeather!
    var dailyArray: [[String: AnyObject]]!
    var weekly: [DailyWeather] = []
    var week: [DailyWeather] = []
    let manager = CLLocationManager()
    var latitudeNew: Double = 0
    var longitudeNew: Double = 0
    var city: String = ""
    var gradientLayer: CAGradientLayer!
    let pre = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        downloadData { () -> () in
            self.configureView()
            self.tableView!.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            self.activityBackground.hidden = true
            self.manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor(red:0.81, green:0.81, blue:0.81, alpha:1)
        refreshControl.tintColor = UIColor(red:1, green:1, blue:1, alpha:1)
        self.tableView.addSubview(self.refreshControl)
        
        getLocation()
        print("viewdid")
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getLocation()
        print("refresh")
        refreshControl.endRefreshing()
    }
    
    func configureView() {
        if let currentWeather = currentDict {
            let current = weekly[0]
            var pressureText: String
            var humidityText: String
            
            if pre == "ru" {
                humidityText = "Влажность\n\(current.humidity)%"
                pressureText = "Давление\n\(current.pressure) мм"
                cityLabel.text = "Сегодня: \(city)"
            } else {
                humidityText = "Humidity\n\(current.humidity)%"
                pressureText = "Pressure\n\(current.pressure)mm"
                cityLabel.text = "\(city) today"
            }
            
            currentLabel.text = "\(currentWeather.temperature)º"
            currentIcon.text = current.icon
            currentDescription.text = current.summary
            currentDayDateLabel.text = "\(current.day.capitalizedString) \(current.date)"
            humidityLabel.text = humidityText
            pressureLabel.text = pressureText
            viewBackground.backgroundColor = currentWeather.color
            addGradient(viewBackground)
            print("configure")
        }
    }
    
    func reverseGeoCoding() {
        let locationNew = CLLocation(latitude: latitudeNew, longitude: longitudeNew)
        
        CLGeocoder().reverseGeocodeLocation(locationNew, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                
                if let town = pm.locality {
                    self.city = town
                }
                print(self.city)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        print("reverse")
    }
    
    func getLocation() {
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        let location = self.manager.location
        
        if let latitude: Double = location?.coordinate.latitude {
            latitudeNew = latitude
            print(latitudeNew)
        }
        
        if let longitude: Double = location?.coordinate.longitude {
            longitudeNew = longitude
            print(longitudeNew)
        }
        print("getloc")
        reverseGeoCoding()
        
    }
    
    func downloadData(completion: DownloadCoplete) {
        
        var weatherURL: String {
            if pre == "ru" {
                return("\(BASE_URL)\(API_KEY)/\(latitudeNew),\(longitudeNew)?units=si&lang=ru")
            } else {
                return("\(BASE_URL)\(API_KEY)/\(latitudeNew),\(longitudeNew)?units=si")
            }
        }
        
        print(weatherURL)
        
        if let url = NSURL(string: weatherURL) {
            let request = Alamofire.request(.GET, url)

            request.validate().responseJSON { response in
                switch response.result {
                case .Success:
                    
                    if let data = response.result.value as! [String: AnyObject]! {
                        
                        self.weatherDict = data["currently"] as! [String: AnyObject]!
                        self.currentDict = CurrentWeather(weatherDictionary: self.weatherDict)
                        
                        self.dailyArray = data["daily"]?["data"] as! [[String: AnyObject]]!
                        for dailyWeather in self.dailyArray {
                            let daily = DailyWeather(dailyWeatherDict: dailyWeather)
                            self.weekly.append(daily)
                        }
                        
                        if self.week.count > 7 || self.weekly.count > 8 {
                            self.week.removeRange(7..<(self.week.count))
                            self.weekly.removeRange(8..<(self.weekly.count))
                        }
                        
                    }
                case .Failure(let error):
                    print(error)
                }
                self.week = self.weekly
                self.week.removeAtIndex(0)
                print("data")
                completion()
            }
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("WeatherViewCell", forIndexPath: indexPath) as? WeatherViewCell {
            
            let index = indexPath.item
            let weeklyWeath = week[index]
            
            var todayLabel: String {
                if pre == "ru" {
                    return("Завтра")
                } else {
                    return("Tomorrow")
                }
            }
            
            if index == 0 {
                cell.dailyTemp.text = "+\(self.week[index].maxTemperature)°"
                cell.dailyIcon.text = self.week[index].icon
                cell.dailyDate.text = "\(todayLabel) \(self.week[index].date)"
                cell.dailySummary.text = self.week[index].summary
                cell.contentView.backgroundColor = self.week[index].color
                return cell
            } else {
                cell.configureCell(weeklyWeath)
                return cell
            }
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return week.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func addGradient(view: UIView) {
        if gradientLayer != nil {
            return
        } else {
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.frame
            let color1 = UIColor(red:0, green:0, blue:0, alpha:0).CGColor as CGColorRef
            let color2 = UIColor(red:0, green:0, blue:0, alpha:0.1).CGColor as CGColorRef
            gradientLayer.colors = [color1, color2]
            gradientLayer.locations = [0.0, 1.0]
            view.layer.insertSublayer(self.gradientLayer, atIndex: UInt32(1))
        }
    }
    
}

