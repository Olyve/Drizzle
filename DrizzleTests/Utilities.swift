//
//  Utilities.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/17/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

@testable import Drizzle
import SwiftyJSON
import SwiftyBeaver

class Utilities {}

extension JSONConvertable {
  static func fromJSONFile(_ file: String = "\(Self.self)") -> Self?
  {
    return JSON(file: file).flatMap(Self.init(from:))
  }
}

extension JSON {
  init?(file: String)
  {
    guard let fileURL = Bundle(for: Utilities.self).url(forResource: file, withExtension: "json"),
          let data = try? Data(contentsOf: fileURL)
      else {
        log.error("Could not parse data from file \(file)");
        return nil }
    
    self.init(data: data)
  }
}
