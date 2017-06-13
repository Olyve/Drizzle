//
//  HomeViewController.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
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
  
  fileprivate var settingsButton: UIBarButtonItem!
  fileprivate var homeLocationButton: UIBarButtonItem!
  
  init(viewModel: HomeViewModelType = HomeViewModel())
  {
    self.viewModel = viewModel
    
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
    
    navigationController?.navigationBar.barStyle = .black
    
//    viewModel.getWeatherForHome()
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
    viewModel.homeLocation
      .observeNext { [weak self] in self?.showChooseLocationIfNoHome(location: $0) }
      .dispose(in: bag)
    
    viewModel.homeLocation
      .observeNext { [weak self] location in
        if let location = location {
          self?.addressLabel.text = location.formattedAddress
          self?.viewModel.getWeatherForHome()
        }
      }
      .dispose(in: bag)
    
    
    setWeatherBindings()
  }
  
  func setWeatherBindings()
  {
    // Current Weather
    viewModel.homeLocation.observeNext { [weak self] location in
      if let location = location,
         let currentWeather = location.currentWeather,
         let dailyWeather = location.dailyWeather?.first {
        self?.bindCurrentWeather(with: currentWeather)
        self?.bindDailyWeather(with: dailyWeather)
      }
      else {
        log.warning("Error: Unable to get weather data from location: \(String(describing: location))")
      }
    }
    .dispose(in: bag)
  }
  
  func bindCurrentWeather(with data: CurrentWeather)
  {
    self.summaryLabel.text = data.summary
    self.temperatureLabel.text = "\(data.temperature)°F"
    self.apparentTemperatureLabel.text = "\(data.apparentTemperature)°F"
    self.weatherIcon.image = UIImage(named: data.icon) ?? UIImage(named: "clear-day")
  }
  
  func bindDailyWeather(with data: DailyWeather)
  {
    self.dailyLowLabel.text = "\(data.temperatureMin)°F"
    self.dailyHighLabel.text = "\(data.temperatureMax)°F"
    self.precipChanceLabel.text = "\(data.precipProbability * 100)%"
    self.humidityLabel.text = "\(data.humidity * 100)%"
    self.windSpeedLabel.text = "\(data.windSpeed) mph"
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
}
