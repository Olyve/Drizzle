//
//  LocationMO+CoreDataProperties.swift
//  Drizzle
//
//  Created by Sam Galizia on 9/26/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationMO> {
        return NSFetchRequest<LocationMO>(entityName: "Location")
    }

    @NSManaged public var address: String?
    @NSManaged public var isHome: Bool
    @NSManaged public var lastFetchTime: Int32
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var useMetric: Bool
    @NSManaged public var currentWeather: CurrentWeatherMO?
    @NSManaged public var dailyWeather: NSOrderedSet?

}

// MARK: Generated accessors for dailyWeather
extension LocationMO {

    @objc(insertObject:inDailyWeatherAtIndex:)
    @NSManaged public func insertIntoDailyWeather(_ value: DailyWeatherMO, at idx: Int)

    @objc(removeObjectFromDailyWeatherAtIndex:)
    @NSManaged public func removeFromDailyWeather(at idx: Int)

    @objc(insertDailyWeather:atIndexes:)
    @NSManaged public func insertIntoDailyWeather(_ values: [DailyWeatherMO], at indexes: NSIndexSet)

    @objc(removeDailyWeatherAtIndexes:)
    @NSManaged public func removeFromDailyWeather(at indexes: NSIndexSet)

    @objc(replaceObjectInDailyWeatherAtIndex:withObject:)
    @NSManaged public func replaceDailyWeather(at idx: Int, with value: DailyWeatherMO)

    @objc(replaceDailyWeatherAtIndexes:withDailyWeather:)
    @NSManaged public func replaceDailyWeather(at indexes: NSIndexSet, with values: [DailyWeatherMO])

    @objc(addDailyWeatherObject:)
    @NSManaged public func addToDailyWeather(_ value: DailyWeatherMO)

    @objc(removeDailyWeatherObject:)
    @NSManaged public func removeFromDailyWeather(_ value: DailyWeatherMO)

    @objc(addDailyWeather:)
    @NSManaged public func addToDailyWeather(_ values: NSOrderedSet)

    @objc(removeDailyWeather:)
    @NSManaged public func removeFromDailyWeather(_ values: NSOrderedSet)

}
