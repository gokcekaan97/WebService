//
//  ViewController.swift
//  WebService
//
//  Created by kaan gokcek on 10.02.2023.
//

import UIKit

class CharacterDetailViewController: UIViewController {
  
  @IBOutlet weak var characterThumbnail: UIImageView!
  @IBOutlet weak var characterComicListLabel: UILabel!
  @IBOutlet weak var characterDescriptionLabel: UILabel!
  @IBOutlet weak var characterNameLabel: UILabel!
  var characterReferance: Character?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let character = characterReferance {
      characterNameLabel.text = character.name
      if character.description != "" {
        characterDescriptionLabel.text = character.description
      } else {
        characterDescriptionLabel.text = "No Description"
      }
      if let characterComicList = character.comics?.items {
        if !characterComicList.isEmpty{
          characterComicListLabel.text = characterComicList.reduce("") {(result, list) -> String in
            if let name = list.name{
              return result + String(describing: "\(name)\n")
            }
            return ""
          }
        } else {
          characterComicListLabel.text = "No Comic List"
        }
      }
      if let characterImageDetail = character.thumbnail?.url{
        downloadImage(from: characterImageDetail)
      } 
    } else {
      print("Can't get character")
    }
  }
  func downloadImage(from url: URL) {
      getData(from: url) { data, response, error in
          guard let data = data, error == nil else { return }
          DispatchQueue.main.async { [weak self] in
            if UIImage(data: data) != nil{
                self?.characterThumbnail.image = UIImage(data: data)
            } else {
              self?.characterThumbnail.image = UIImage(named: "notFound")
            }
          }
      }
  }
  func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
}

