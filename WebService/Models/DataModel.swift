//
//  DataModel.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation

struct DataContainer: Decodable {
  private let offset:Int? // The requested offset (skipped results) of the call
  private let limit:Int? // The requested result limit
  private let total:Int? // The total number of results available
  private let count:Int? // The total number of results returned by this call
  private let results:[Character]? // The list of entities returned by the call
  
  enum CodingKeys: CodingKey {
    case offset
    case limit
    case total
    case count
    case results
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.offset = try container.decode(Int.self, forKey: .offset)
    self.limit = try container.decode(Int.self, forKey: .limit)
    self.total = try container.decode(Int.self, forKey: .total)
    self.count = try container.decode(Int.self, forKey: .count)
    self.results = try container.decode([Character].self, forKey: .results)
  }
}
