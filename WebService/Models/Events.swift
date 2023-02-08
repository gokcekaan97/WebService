//
//  Events.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation

struct Events: Codable {
    
    let resourceURI: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case resourceURI
        case name
    }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.resourceURI, forKey: .resourceURI)
    try container.encodeIfPresent(self.name, forKey: .name)
  }
}
