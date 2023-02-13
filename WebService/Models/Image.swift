//
//  Image.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation

struct Image: Codable {
  
  
  let path:String? // (string, optional): The directory path of to the image.,
  let pathExtension:String? // (string, optional): The file extension for the image.
  var url: URL? {
    if let path = path{
      var tempString: String = path
      tempString.insert("s", at: tempString.index(tempString.startIndex, offsetBy: 4))
      return URL(string: "\(tempString)/portrait_uncanny.jpg")
    } else {
      return nil
    }
  }
  
  enum CodingKeys: CodingKey {
    case path
    case pathExtension
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.path = try container.decodeIfPresent(String.self, forKey: .path)
    self.pathExtension = try container.decodeIfPresent(String.self, forKey: .pathExtension)
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.path, forKey: .path)
    try container.encodeIfPresent(self.pathExtension, forKey: .pathExtension)
  }
}
