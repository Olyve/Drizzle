//
//  JSONConvertable.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/17/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import SwiftyJSON

protocol JSONConvertable {
  typealias conformer = Self
  
  func toJSON() -> JSON
  init?(from json: JSON)
}
