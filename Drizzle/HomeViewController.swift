//
//  HomeViewController.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import CoreData
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
  
  private let managedContext: NSManagedObjectContext!
  private let viewModel: HomeViewModelType
  private var settingsButton: UIBarButtonItem!
  private var homeLocationButton: UIBarButtonItem!
  private var temp_measure = Observable<String>("")
  private var windSpeed_measure = Observable<String>("")
  
  init(managedContext: NSManagedObjectContext)
  {
    self.managedContext = managedContext
    self.viewModel = HomeViewModel(managedContext: self.managedContext)
    
    super.init(nibName: "HomeViewController", bundle: nil)
    
    settingsButton = UIBarButtonItem(image: UIImage(named: "settings"),
                                     style: .done,
                                     target: self,
                                     action: #selector(showSettings))
    homeLocationButton = UIBarButtonItem(image: UIImage(named: "home"),
                                         style: .done,
                                         target: self,
                                         action: #selector(showChooseLocation))
    
    viewModel.useMetric
      .map { $0 ? "ºC" : "ºF" }
      .bind(to: temp_measure)
    
    viewModel.useMetric
      .map { $0 ? "m/s" : "mph" }
      .bind(to: windSpeed_measure)
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
    
    viewModel.updateWeatherInfo()
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
          self?.addressLabel.text = location.address
        }
      }
      .dispose(in: bag)
    
    
    setWeatherBindings()
  }
  
  func setWeatherBindings()
  {
    // Current Weather
    viewModel.homeLocation.observeNext { [weak self] homeLocation in
      guard let location = homeLocation,
            let currentWeather = location.currentWeather,
            let dailyWeather = location.dailyWeather?[0] as? DailyWeatherMO
        else { log.warning("Warning: Unable to get weather for: \(String(describing: homeLocation))"); return }
      
      self?.bindCurrentWeather(with: currentWeather)
      self?.bindDailyWeather(with: dailyWeather)
    }
    .dispose(in: bag)
  }
  
  func bindCurrentWeather(with data: CurrentWeatherMO)
  {
    self.summaryLabel.text = data.summary
    self.temperatureLabel.text = "\(data.temperature)\(temp_measure.value)"
    self.apparentTemperatureLabel.text = "\(data.apparentTemperature)\(temp_measure.value)"
    self.weatherIcon.image = UIImage(named: data.icon!) ?? UIImage(named: "clear-day")
  }
  
  func bindDailyWeather(with data: DailyWeatherMO)
  {
    self.dailyLowLabel.text = "\(data.temperatureMin)\(temp_measure.value)"
    self.dailyHighLabel.text = "\(data.temperatureMax)\(temp_measure.value)"
    self.precipChanceLabel.text = "\(data.precipProbability * 100)%"
    self.humidityLabel.text = "\(data.humidity * 100)%"
    self.windSpeedLabel.text = "\(data.windSpeed) \(windSpeed_measure.value)"
  }
  
  func showChooseLocationIfNoHome(location: LocationMO?)
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
    let chooseLocationViewController = ChooseLocationViewController(managedContext: managedContext)
    navigationController?.pushViewController(chooseLocationViewController, animated: true)
  }
}
