//
//  Service.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation
import CryptoKit

class Service {
  private let limit = 30
  
  func downloadCharacters(_ name: String?,page: Int,characterEndpoint: CharacterEndpoint, completion: @escaping (Result<RequestBody,NSError>) -> Void) {
    
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
        customQueryItems.append(URLQueryItem(name: "nameStartsWith", value: name))
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
      guard let requestBody = try? JSONDecoder().decode(RequestBody.self, from: data) else {
        return completion(.failure(NSError(domain: "", code: 000, userInfo: ["message": "Can't parse json"])))
      }
      completion(.success(requestBody))
      return
    }.resume()
  }
}

extension String {
  
  var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}


