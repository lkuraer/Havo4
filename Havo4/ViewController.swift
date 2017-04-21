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
import RxSwift
import RxCocoa

class ViewController: UIViewController, CLLocationManagerDelegate {
    
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
    
    let disposeBag = DisposeBag()
    var week = Variable<[DailyWeather]>([])
    
    let manager = CLLocationManager()
    var latitudeNew: Double = 0
    var longitudeNew: Double = 0
    var city: String = ""
    var gradientLayer: CAGradientLayer!
    let pre = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        week.asObservable().subscribe(onNext: {
            week in
            print(week.count)
            self.generateTable()
        }).addDisposableTo(disposeBag)
        
        tableView.backgroundColor = UIColor(red:0.81, green:0.81, blue:0.81, alpha:1)
        refreshControl.tintColor = UIColor(red:1, green:1, blue:1, alpha:1)
        self.tableView.addSubview(self.refreshControl)
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        updateLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitudeNew = location.coordinate.latitude
            longitudeNew = location.coordinate.longitude
        }
        downloadData {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.configureView()
            self.manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        updateLocation()
        self.refreshControl.endRefreshing()
    }
    
    func updateLocation() {
        manager.startUpdatingLocation()
        activityIndicator.isHidden = false
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
        
        if let currentTemp = currentWeather?.temperature {
            currentLabel.text = "\(currentTemp)º"
        }
        
        currentIcon.text = current.icon
        currentDescription.text = current.summary
        
        if let currentDay = currentWeather?.day.capitalized {
            currentDayDateLabel.text = "\(currentDay) \(current.date)"
        }
        
        minTempToday.text = "\(current.minTemperature)º"
        maxTempToday.text = "\(current.maxTemperature)º"
        viewBackground.backgroundColor = currentWeather?.color
        addGradient(viewBackground)

        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        activityBackground.isHidden = true
        
    }
    
    func reverseGeoCoding(_ completion: @escaping ReverseComplete) {
        
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
    
    func downloadData(_ completion: @escaping DownloadComplete) {
        
        var weatherURL: String {
            if pre == "ru" {
                return("\(BASE_URL)\(API_KEY)/\(latitudeNew),\(longitudeNew)?units=si&lang=ru")
            } else {
                return("\(BASE_URL)\(API_KEY)/\(latitudeNew),\(longitudeNew)?units=si")
            }
        }
        
        print(weatherURL)
        
        if let url = URL(string: weatherURL) {
            let request = Alamofire.request(url)
            
            request.validate().responseJSON { response in
                switch response.result {
                case .success:
                    
                    self.week.value = []

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
                                self.week.value.append(self.weekly[x])
                            }
                        }
                        completion()
                    }
                    
                case .failure(let error):
                    self.showAlert("You are offline", message: "Enable network connection and try again")
                    print("Alamofire error: \(error)")
                }
                
            }

        }
    }
    
    func generateTable() {
        tableView.dataSource = nil
        week.asObservable().bindTo(tableView.rx.items(cellIdentifier: "WeatherViewCell", cellType: WeatherViewCell.self)) { (index, weather, cell) in
            cell.configureCell(daily: weather, index: index)
            }.addDisposableTo(disposeBag)

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
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { refreshPressed in
            self.updateLocation()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

