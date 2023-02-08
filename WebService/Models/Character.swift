//
//  Character.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation

struct Character: Decodable {
  
  private let id:Int? // (int, optional): The unique ID of the character resource.,
  private let name:String? // (string, optional): The name of the character.,
  private let description:String? // (string, optional): A short bio or description of the character.,
  private var thumbnail:Image? // (Image, optional): The representative image for this character.,
  
  enum CodingKeys: CodingKey {
    case id
    case name
    case description
    case thumbnail
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.description = try container.decode(String.self, forKey: .description)
    self.thumbnail = try container.decode(Image.self, forKey: .thumbnail)
  }
}
