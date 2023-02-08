//
//  RequestModel.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation

struct RequestBody: Decodable  {
  let code: Int?
  let status: String?
  let copyright: String?
  let attributionText: String?
  let attributionHTML: String?
  let data: Character?
  let etag: String?
  
  enum CodingKeys: String, CodingKey {
    case code
    case status
    case copyright
    case attributionText
    case attributionHTML
    case data
    case etag
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.code = try container.decode(Int.self, forKey: .code)
    self.status = try container.decode(String.self, forKey: .status)
    self.copyright = try container.decode(String.self, forKey: .copyright)
    self.attributionText = try container.decode(String.self, forKey: .attributionText)
    self.attributionHTML = try container.decode(String.self, forKey: .attributionHTML)
    self.data = try container.decode(Character.self, forKey: .data)
    self.etag = try container.decode(String.self, forKey: .etag)
  }
}
  
