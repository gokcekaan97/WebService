//
//  CharacterSummary.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import Foundation

struct CharacterSummary: Codable {
  
  let role: String?
  let resourceURI: String?
  let name: String?
  
  enum CodingKeys: String, CodingKey {
    case resourceURI
    case name
    case role
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI)
    self.role = try container.decodeIfPresent(String.self, forKey: .role)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.resourceURI, forKey: .resourceURI)
    try container.encodeIfPresent(self.role, forKey: .role)
    try container.encodeIfPresent(self.name, forKey: .name)
  }
  
}
