//
//  ComicDataWrapper.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import Foundation

struct ComicDataWrapper: Codable  {
  let code: Int?
  let status: String?
  let copyright: String?
  let attributionText: String?
  let attributionHTML: String?
  let etag: String?
  let data: ComicDataContainer?
  
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
    self.code = try container.decodeIfPresent(Int.self, forKey: .code)
    self.status = try container.decodeIfPresent(String.self, forKey: .status)
    self.copyright = try container.decodeIfPresent(String.self, forKey: .copyright)
    self.attributionText = try container.decodeIfPresent(String.self, forKey: .attributionText)
    self.attributionHTML = try container.decodeIfPresent(String.self, forKey: .attributionHTML)
    self.data = try container.decodeIfPresent(ComicDataContainer.self, forKey: .data)
    self.etag = try container.decodeIfPresent(String.self, forKey: .etag)
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.code, forKey: .code)
    try container.encodeIfPresent(self.status, forKey: .status)
    try container.encodeIfPresent(self.copyright, forKey: .copyright)
    try container.encodeIfPresent(self.attributionText, forKey: .attributionText)
    try container.encodeIfPresent(self.attributionHTML, forKey: .attributionHTML)
    try container.encodeIfPresent(self.data, forKey: .data)
    try container.encodeIfPresent(self.etag, forKey: .etag)
  }
}
