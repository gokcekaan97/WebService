//
//  EventList.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation

struct EventList: Codable {
    
  let available: Int?
  let returned: Int?
  let collectionURI: String?
  let items: [Events]?
  
  enum CodingKeys: String, CodingKey {
    case available
    case returned
    case collectionURI
    case items
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.available = try container.decodeIfPresent(Int.self, forKey: .available)
    self.returned = try container.decodeIfPresent(Int.self, forKey: .returned)
    self.collectionURI = try container.decodeIfPresent(String.self, forKey: .collectionURI)
    self.items = try container.decodeIfPresent([Events].self, forKey: .items)
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.available, forKey: .available)
    try container.encodeIfPresent(self.returned, forKey: .returned)
    try container.encodeIfPresent(self.collectionURI, forKey: .collectionURI)
    try container.encodeIfPresent(self.items, forKey: .items)
  }
}
