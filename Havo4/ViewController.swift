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
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentIcon: UILabel!
    @IBOutlet weak var currentDescription: UILabel!
    @IBOutlet weak var currentDayDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currently: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var maximum: UILabel!
    @IBOutlet weak var minimum: UILabel!
    @IBOutlet weak var minTempToday: UILabel!
    @IBOutlet weak var maxTempToday: UILabel!
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
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        updateLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        updateLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitudeNew = location.coordinate.latitude
            longitudeNew = location.coordinate.longitude
        }
        downloadData {
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
            self.configureView()
            self.tableView!.reloadData()
            self.manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        updateLocation()
        self.refreshControl.endRefreshing()
    }
    
    func updateLocation() {
        manager.startUpdatingLocation()
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    func getCity() {
        reverseGeoCoding {
            if self.pre == "ru" {
                self.cityLabel.text = "\(self.city) сейчас"
            } else {
                self.cityLabel.text = "\(self.city) now"
            }
        }
    }
    
    func configureView() {
        getCity()
        let currentWeather = currentDict
        let current = weekly[0]
        
        if pre == "ru" {
            minimum.text = "Минимум"
            maximum.text = "Максимум"
        } else {
            minimum.text = "Minimum"
            maximum.text = "Maximum"
        }
        
        currentLabel.text = "\(currentWeather.temperature)º"
        currentIcon.text = current.icon
        currentDescription.text = current.summary
        currentDayDateLabel.text = "\(currentWeather.day.capitalizedString) \(current.date)"
        minTempToday.text = "\(current.minTemperature)º"
        maxTempToday.text = "\(current.maxTemperature)º"
        viewBackground.backgroundColor = currentWeather.color
        addGradient(viewBackground)

        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        activityBackground.hidden = true
        
    }
    
    func reverseGeoCoding(completion: ReverseComplete) {
        
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
                    completion()
                }
                print("reversed to \(self.city)")
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    func downloadData(completion: DownloadComplete) {
        
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
                    self.week = []
                    self.weekly = []
                    if let data = response.result.value as! [String: AnyObject]! {
                        
                        self.weatherDict = data["currently"] as! [String: AnyObject]!
                        self.currentDict = CurrentWeather(weatherDictionary: self.weatherDict)
                        
                        self.dailyArray = data["daily"]?["data"] as! [[String: AnyObject]]!
                        for dailyWeather in self.dailyArray {
                            let daily = DailyWeather(dailyWeatherDict: dailyWeather)
                            self.weekly.append(daily)
                            
                        }
                        for x in 0...7 {
                            if x == 0 {
                            } else {
                                self.week.append(self.weekly[x])
                            }
                        }
                        completion()
                    }
                    
                case .Failure(let error):
                    self.showAlert("You are offline", message: "Enable network connection and try again")
                    print("Alamofire error: \(error)")
                }
                
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
                cell.dailyTemp.text = "\(self.week[index].maxTemperature)°"
                cell.dailyIcon.text = self.week[index].icon
                cell.dailyDay.text = "\(todayLabel)"
                cell.dailySummary.text = self.week[index].summary
                cell.dailyDate.text = ""
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
            let color1 = UIColor(red:1, green:1, blue:1, alpha:0.07).CGColor as CGColorRef
            let color2 = UIColor(red:1, green:1, blue:1, alpha:0).CGColor as CGColorRef
            gradientLayer.colors = [color1, color2]
            gradientLayer.locations = [0.0, 1.0]
            view.layer.insertSublayer(self.gradientLayer, atIndex: UInt32(1))
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { refreshPressed in
            self.updateLocation()
        }
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
}

