//
//  CurrentWeatherMO+CoreDataProperties.swift
//  Drizzle
//
//  Created by Sam Galizia on 9/26/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrentWeatherMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherMO> {
        return NSFetchRequest<CurrentWeatherMO>(entityName: "CurrentWeather")
    }

    @NSManaged public var apparentTemperature: Int16
    @NSManaged public var icon: String?
    @NSManaged public var summary: String?
    @NSManaged public var temperature: Int16
    @NSManaged public var location: LocationMO?

}
