//
//  ComicService.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import Foundation

class ComicService {
  private let limit = 20
  
  func downloadComics(_ title : String?,_ name: String?,page: Int, comicEndpoint: ComicEndpoint, completion: @escaping (Result<ComicDataWrapper,NSError>) -> Void) {
    
    let timestamp = "1"
    let hash = "\(timestamp)\(comicEndpoint.privateKey)\(comicEndpoint.apiKey)".MD5
    let tempURLString = URL(string: comicEndpoint.baseURL + "/" + comicEndpoint.path)
    var components = URLComponents(url: tempURLString!, resolvingAgainstBaseURL: true)
    var customQueryItems = [URLQueryItem]()
    if let name = name, name != "" {
      customQueryItems.append(URLQueryItem(name: "titleStartsWith", value: name))
    }
    if page > 0 {
      customQueryItems.append(URLQueryItem(name: "offset", value: "\(page * limit)"))
    }
    let commonQueryItems = [
      URLQueryItem(name: "ts", value: timestamp),
      URLQueryItem(name: "apikey", value: comicEndpoint.apiKey),
      URLQueryItem(name: "hash", value: hash)
    ]

    if title != "" {
      customQueryItems.append(URLQueryItem(name: "orderBy", value: title))
    }
    
    components?.queryItems = commonQueryItems + customQueryItems
    
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



