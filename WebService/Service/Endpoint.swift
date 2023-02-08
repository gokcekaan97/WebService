//
//  Endpoint.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation

protocol Endpoint {
  
  var path: String { get }
  var baseURL: String { get }
  var method: RequestMethod { get }
  var privateKey: String { get }
  var apiKey: String { get }
}

extension Endpoint {
  var privateKey: String {
    return "d6904e84cf013801226f3ab85e08502cfd48de60"
  }
  var apiKey: String {
    return "0f21652853909fd72695c1619570c318"
  }
  var baseURL: String {
      return "https://gateway.marvel.com"
  }
}

enum RequestMethod: String {
  
  case delete = "DELETE"
  case get = "GET"
  case patch = "PATCH"
  case post = "POST"
  case put = "PUT"
}
