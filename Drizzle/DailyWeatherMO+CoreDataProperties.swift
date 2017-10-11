//
//  DailyWeatherMO+CoreDataProperties.swift
//  Drizzle
//
//  Created by Sam Galizia on 9/26/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//
//

import Foundation
import CoreData


extension DailyWeatherMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeatherMO> {
        return NSFetchRequest<DailyWeatherMO>(entityName: "DailyWeather")
    }

    @NSManaged public var humidity: Double
    @NSManaged public var icon: String?
    @NSManaged public var precipProbability: Double
    @NSManaged public var precipType: String?
    @NSManaged public var summary: String?
    @NSManaged public var temperatureMax: Int16
    @NSManaged public var temperatureMin: Int16
    @NSManaged public var time: Int32
    @NSManaged public var windSpeed: Double
    @NSManaged public var location: LocationMO?

}
