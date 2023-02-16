//
//  ComicService.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import Foundation

class ComicService {
  private let limit = 30
  
  func downloadComics(_ name: String?,page: Int,characterEndpoint: ComicEndpoint, completion: @escaping (Result<ComicDataWrapper,NSError>) -> Void) {
    
    let timestamp = "1"
    let hash = "\(timestamp)\(characterEndpoint.privateKey)\(characterEndpoint.apiKey)".MD5
    var customQueryItems = [URLQueryItem]()
    let commonQueryItems = [
      URLQueryItem(name: "offset", value: "\(page * limit)"),
      URLQueryItem(name: "limit", value: "\(limit)"),
      URLQueryItem(name: "ts", value: timestamp),
      URLQueryItem(name: "apikey", value: characterEndpoint.apiKey),
      URLQueryItem(name: "hash", value: hash)
    ]
    let searchQueryItems = [
      URLQueryItem(name: "ts", value: timestamp),
      URLQueryItem(name: "apikey", value: characterEndpoint.apiKey),
      URLQueryItem(name: "hash", value: hash)
    ]
    if name != "" {
        customQueryItems.append(URLQueryItem(name: "titleStartsWith", value: name))
    }
    
    
    let tempURLString = URL(string: characterEndpoint.baseURL + "/" + characterEndpoint.path)
    var components = URLComponents(url: tempURLString!, resolvingAgainstBaseURL: true)
    if customQueryItems != []{
      components?.queryItems = customQueryItems + searchQueryItems
    } else {
      components?.queryItems = commonQueryItems
    }
    
    guard let url = components?.url else {
      return completion(.failure(NSError(domain: "", code: 000, userInfo: ["message": "Can't build url"])))
    }
    URLSession.shared.dataTask(with: url){ data, response, error in
      guard let data = data, error == nil else {
        return completion(.failure(NSError(domain: "", code: 000, userInfo: ["message": "Can't get data"])))
      }
      guard let requestBody = try? JSONDecoder().decode(ComicDataWrapper.self, from: data) else {
        return completion(.failure(NSError(domain: "", code: 000, userInfo: ["message": "Can't parse json"])))
      }
      completion(.success(requestBody))
      return
    }.resume()
  }
}



