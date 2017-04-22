//
//  NetworkClient.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/17/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Foundation
import PromiseKit

protocol NetworkClientType {
  func makeRequest(urlString: String) -> Promise<Data>
}

class NetworkClient: NetworkClientType {
  enum Errors: Error {
    case malformedURL
    case notAnHTTPRequest
    case badRequest
    case noData
  }
  
  fileprivate let session = URLSession.shared
  
  func makeRequest(urlString: String) -> Promise<Data>
  {
    let (promise, fulfill, reject) = Promise<Data>.pending()
    
    guard let url = URL(string: urlString)
      else { return Promise<Data>(error: Errors.malformedURL) }
    
    let task = session.dataTask(with: url) { (data, response, error) in
      guard let httpResponse = response as? HTTPURLResponse
        else { reject(Errors.notAnHTTPRequest); return }
      
      if error != nil && httpResponse.statusCode == 400 {
        reject(Errors.badRequest)
        let errorString = error?.localizedDescription ?? ""
        NSLog("\(httpResponse.statusCode) \(url): \n\(errorString)")
      }
      else if data != nil && httpResponse.statusCode == 200 {
        guard let data = data else { reject(Errors.noData); return }
        
        fulfill(data)
      }
    }
    task.resume()
    
    return promise
  }
}
