//
//  ComicDataContainer.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import Foundation

struct ComicDataContainer: Codable {
  
  let offset:Int? // The requested offset (skipped results) of the call
  let limit:Int? // The requested result limit
  let total:Int? // The total number of results available
  let count:Int? // The total number of results returned by this call
  let results:[Comic]? // The list of entities returned by the call
  
  enum CodingKeys: CodingKey {
    case offset
    case limit
    case total
    case count
    case results
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.offset = try container.decodeIfPresent(Int.self, forKey: .offset)
    self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
    self.total = try container.decodeIfPresent(Int.self, forKey: .total)
    self.count = try container.decodeIfPresent(Int.self, forKey: .count)
    self.results = try container.decodeIfPresent([Comic].self, forKey: .results)
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.offset, forKey: .offset)
    try container.encodeIfPresent(self.limit, forKey: .limit)
    try container.encodeIfPresent(self.total, forKey: .total)
    try container.encodeIfPresent(self.count, forKey: .count)
    try container.encodeIfPresent(self.results, forKey: .results)
  }
}
