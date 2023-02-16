//
//  Comic.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import Foundation

struct Comic: Codable {
  
  let id:Int? // (int, optional): The unique ID of the character resource.,
  let title:String?
  let description:String? // (string, optional): A short bio or description of the character.,
  var thumbnail: Image? // (Image, optional): The representative image for this character.,
  let creators: CreatorsList?
  let characters: CharactersList?

  
  enum CodingKeys: CodingKey {
    case id
    case title
    case description
    case thumbnail
    case creators
    case characters
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.title = try container.decodeIfPresent(String.self, forKey: .title)
    self.description = try container.decodeIfPresent(String.self, forKey: .description)
    self.thumbnail = try container.decodeIfPresent(Image.self, forKey: .thumbnail)
    self.creators = try container.decodeIfPresent(CreatorsList.self, forKey: .creators)
    self.characters = try container.decodeIfPresent(CharactersList.self, forKey: .characters)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.id, forKey: .id)
    try container.encodeIfPresent(self.title, forKey: .title)
    try container.encodeIfPresent(self.description, forKey: .description)
    try container.encodeIfPresent(self.thumbnail, forKey: .thumbnail)
    try container.encodeIfPresent(self.creators, forKey: .creators)
    try container.encodeIfPresent(self.characters, forKey: .characters)
  }
}
