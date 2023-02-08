//
//  Stories.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation

struct Stories: Codable {
    
  let resourceURI: String?
  let name: String?
  let type: String?
  
  enum CodingKeys: String, CodingKey {
    case resourceURI
    case name
    case type
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
    self.type = try container.decodeIfPresent(String.self, forKey: .type)
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.resourceURI, forKey: .resourceURI)
    try container.encodeIfPresent(self.name, forKey: .name)
    try container.encodeIfPresent(self.type, forKey: .type)
  }
}

