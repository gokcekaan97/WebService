//
//  CharacterEndpoint.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation

class CharacterEndpoint: Endpoint {
  var method: RequestMethod {
    return .get
  }
  
  var path: String {
    return "v1/public/characters"
  }
}
