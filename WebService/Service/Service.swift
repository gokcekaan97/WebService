//
//  Service.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import Foundation
import CryptoKit

class Service {
  
  func downloadCharacters(characterEndpoint: CharacterEndpoint, completion: @escaping (Result<RequestBody?,DownloaderError>) -> Void) {
    
    let timestamp = "1"
    let hash = "\(timestamp)\(characterEndpoint.privateKey)\(characterEndpoint.apiKey)".MD5
    let commonQueryItems = [
                URLQueryItem(name: "apikey", value: characterEndpoint.apiKey),
                URLQueryItem(name: "ts", value: timestamp),
                URLQueryItem(name: "hash", value: hash),
                URLQueryItem(name: "offset", value: "\(1 * 20)"),
                URLQueryItem(name: "name", value: "name")
    ]
    
    let tempURLString = URL(string: characterEndpoint.baseURL + "/" + characterEndpoint.path)
    var components = URLComponents(url: tempURLString!, resolvingAgainstBaseURL: true)
    components?.queryItems = commonQueryItems
    print(components?.url)
    guard let url = components?.url else {
      return completion(.failure(.badUrl))
    }
    URLSession.shared.dataTask(with: url){ data, response, error in
      guard let data = data, error == nil else {
        return completion(.failure(.noData))
      }
      guard let requestBody = try? JSONDecoder().decode(RequestBody.self, from: data) else {
        return completion(.failure(.dataParseError))
      }
      completion(.success(requestBody))
    }.resume()
  }
}

extension String {
var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

enum DownloaderError: Error {
  case badUrl
  case noData
  case dataParseError
}


