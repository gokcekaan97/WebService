//
//  ComicEndpoint.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import Foundation

class ComicEndpoint: Endpoint {
  var method: RequestMethod {
    return .get
  }
  
  var path: String {
    return "v1/public/comics"
  }
}
