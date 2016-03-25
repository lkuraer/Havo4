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
    var weatherDict: [String: AnyObject]!
    var currentDict: CurrentWeather!
    var dailyArray: [[String: AnyObject]]!
    var weekly: [DailyWeather] = []
    let manager = CLLocationManager()
    var latitudeNew: Double = 0
    var longitudeNew: Double = 0
    var gradientLayer: CAGradientLayer!
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            downloadData { () -> () in
                self.configureView()
                self.tableView!.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.activityBackground.hidden = true
                print("You are here: \(location)")
                print("I'm getting temperature here \(self.currentDict.temperature)")
            }
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
        
        reverseGeoCoding()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func configureView() {
        if let currentWeather = currentDict {
            
            let current = weekly[0]
            currentLabel.text = "\(currentWeather.temperature)º"
            currentIcon.text = current.icon
            currentDescription.text = current.summary
            currentDayDateLabel.text = "\(current.day) \(current.date)"
            viewBackground.backgroundColor = currentWeather.color
            addGradient(viewBackground)
        }
    }
    
    func reverseGeoCoding() {
        
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.requestLocation()
        
        let location = self.manager.location
        
        if let latitude: Double = location?.coordinate.latitude {
            latitudeNew = latitude
            print(latitudeNew)
        }
        
        if let longitude: Double = location?.coordinate.longitude {
            longitudeNew = longitude
            print(longitudeNew)
        }
        
        let locationNew = CLLocation(latitude: latitudeNew, longitude: longitudeNew)
        
        CLGeocoder().reverseGeocodeLocation(locationNew, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                
                if let city = pm.locality {
                    self.cityLabel!.text = "\(city) сегодня"
                }
                
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func downloadData(completion: DownloadCoplete) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        let weatherURL = "\(BASE_URL)\(API_KEY)/\(latitudeNew),\(longitudeNew)?units=si&lang=ru"
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
                    }
                    
                case .Failure(let error):
                    print(error)
                }
                completion()
            }
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("WeatherViewCell", forIndexPath: indexPath) as? WeatherViewCell {
            
            let index = indexPath.item
            let weeklyWeath = weekly[index]
//            let currentWeath = currentDict
            
            cell.configureCell(weeklyWeath)
            
            return cell
            
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekly.count
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
            let color2 = UIColor(red:0, green:0, blue:0, alpha:0.05).CGColor as CGColorRef
            gradientLayer.colors = [color1, color2]
            gradientLayer.locations = [0.0, 1.0]
            view.layer.insertSublayer(self.gradientLayer, atIndex: UInt32(1))
        }
    }
    
}

