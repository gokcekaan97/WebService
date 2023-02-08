//
//  Character.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation

struct Character: Codable {
  
  let id:Int? // (int, optional): The unique ID of the character resource.,
  let name:String? // (string, optional): The name of the character.,
  let description:String? // (string, optional): A short bio or description of the character.,
  var thumbnail:Image? // (Image, optional): The representative image for this character.,
  let comics: ComicList?
  let series: SeriesList?
  let stories: StoryList?
  let events: EventList?
  
  enum CodingKeys: CodingKey {
    case id
    case name
    case description
    case thumbnail
    case comics
    case series
    case stories
    case events
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
    self.description = try container.decodeIfPresent(String.self, forKey: .description)
    self.thumbnail = try container.decodeIfPresent(Image.self, forKey: .thumbnail)
    self.comics = try container.decodeIfPresent(ComicList.self, forKey: .comics)
    self.series = try container.decodeIfPresent(SeriesList.self, forKey: .series)
    self.stories = try container.decodeIfPresent(StoryList.self, forKey: .stories)
    self.events = try container.decodeIfPresent(EventList.self, forKey: .events)
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.id, forKey: .id)
    try container.encodeIfPresent(self.name, forKey: .name)
    try container.encodeIfPresent(self.description, forKey: .description)
    try container.encodeIfPresent(self.thumbnail, forKey: .thumbnail)
    try container.encodeIfPresent(self.comics, forKey: .comics)
    try container.encodeIfPresent(self.series, forKey: .series)
    try container.encodeIfPresent(self.stories, forKey: .stories)
    try container.encodeIfPresent(self.events, forKey: .events)
  }
}
