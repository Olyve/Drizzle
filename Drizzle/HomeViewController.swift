//
//  HomeViewController.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

class HomeViewController: UIViewController {
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var apparentTemperatureLabel: UILabel!
  @IBOutlet weak var dailyLowLabel: UILabel!
  @IBOutlet weak var dailyHighLabel: UILabel!
  @IBOutlet weak var precipChanceLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var windSpeedLabel: UILabel!
  
  fileprivate let viewModel: HomeViewModelType
  fileprivate let weatherManager: WeatherManagerType
  
  fileprivate let disposeBag = DisposeBag()
  fileprivate var settingsButton: UIBarButtonItem!
  fileprivate var homeLocationButton: UIBarButtonItem!
  
  init(viewModel: HomeViewModelType = HomeViewModel(),
       weatherManager: WeatherManagerType = WeatherManager())
  {
    self.viewModel = viewModel
    self.weatherManager = weatherManager
    
    super.init(nibName: "HomeViewController", bundle: nil)
    
    settingsButton = UIBarButtonItem(image: UIImage(named: "settings"),
                                     style: .done,
                                     target: self,
                                     action: #selector(showSettings))
    homeLocationButton = UIBarButtonItem(image: UIImage(named: "home"),
                                         style: .done,
                                         target: self,
                                         action: #selector(showChooseLocation))
    
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Lifecycle
extension HomeViewController {
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    setBindings()
    
    navigationItem.leftBarButtonItem = settingsButton
    navigationItem.rightBarButtonItem = homeLocationButton
    navigationItem.leftBarButtonItem?.tintColor = UIColor.drizzleWhite
    navigationItem.rightBarButtonItem?.tintColor = UIColor.drizzleWhite
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    
    fetchWeather()
    navigationController?.navigationBar.barStyle = .black
  }
  
  override func viewWillDisappear(_ animated: Bool)
  {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.barStyle = .default
  }
}

// MARK: - Helpers
fileprivate extension HomeViewController {
  func setBindings()
  {
    viewModel.homeLocation.asObservable()
      .subscribe(onNext: { self.showChooseLocationIfNoHome(location: $0) })
      .addDisposableTo(disposeBag)
    
    viewModel.homeLocation.asObservable()
      .subscribe(onNext: { location in
        if let location = location {
          self.addressLabel.text = location.formattedAddress
          self.weatherManager.getWeatherForHome()
        }
      })
      .addDisposableTo(disposeBag)
    
    setWeatherBindings()
  }
  
  func setWeatherBindings()
  {
    weatherManager.currentWeather.asObservable()
      .subscribe(onNext: { json in
        if let json = json {
          self.summaryLabel.text = json["summary"].stringValue
          self.temperatureLabel.text = String(json["temperature"].intValue) + "°F"
          self.apparentTemperatureLabel.text = String(json["apparentTemperature"].intValue) + "°F"
          
          let icon = self.weatherManager.getWeatherIcon()
          self.weatherIcon.image = UIImage(named: icon) ?? UIImage(named: "clear-day")
        }
        else {
          guard let json = json
            else { return log.warning("Error: Unable to get current weather data.") }
          
          log.warning("Error: Unable to get current weather from JSON: \(json)")
        }
      })
      .addDisposableTo(disposeBag)
    
    weatherManager.dailyWeather.asObservable()
      .subscribe(onNext: { json in
        guard let json = json
          else { return NSLog("Error: Unable to parse daily weather data.") }
        
        let data = json["data"][0]
            
        self.dailyLowLabel.text = String(data["temperatureMin"].intValue) + "°F"
        self.dailyHighLabel.text = String(data["temperatureMax"].intValue) + "°F"
        self.precipChanceLabel.text = String(data["precipProbability"].doubleValue * 100) + "%"
        self.humidityLabel.text = String(data["humidity"].doubleValue * 100) + "%"
        self.windSpeedLabel.text = String(data["windSpeed"].doubleValue) + " mph"
      })
      .addDisposableTo(disposeBag)
  }
  
  func showChooseLocationIfNoHome(location: Location?)
  {
    if location == nil {
      showChooseLocation()
    }
  }
  
  @objc func showSettings()
  {
    let settingsViewController = SettingsViewController()
    navigationController?.pushViewController(settingsViewController, animated: true)
  }
  
  @objc func showChooseLocation()
  {
    let chooseLocationViewController = ChooseLocationViewController()
    navigationController?.pushViewController(chooseLocationViewController, animated: true)
  }
  
  func fetchWeather()
  {
    weatherManager.getWeatherForHome()
  }
}
