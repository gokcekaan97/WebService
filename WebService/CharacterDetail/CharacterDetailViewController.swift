//
//  ViewController.swift
//  WebService
//
//  Created by kaan gokcek on 10.02.2023.
//

import UIKit
import Kingfisher

class CharacterDetailViewController: UIViewController {
  
  @IBOutlet weak var characterThumbnail: UIImageView!
  @IBOutlet weak var characterComicListLabel: UILabel!
  @IBOutlet weak var characterDescriptionLabel: UILabel!
  @IBOutlet weak var characterNameLabel: UILabel!
  var characterReferance: Character?
  weak var characterDelegate: CharacterDetail?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.characterReferance = characterDelegate?.setCharacterDetail()
    
    setCharacterView()
    
  }
  
  func setCharacterView(){
    if let character = characterReferance {
      characterNameLabel.text = character.name
      title = character.name
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
      if let characterImageDetail = character.thumbnail?.landscapeIncredibleURL{
        characterThumbnail.kf.setImage(with: characterImageDetail)
      }
    } else {
      print("Can't get character")
    }
  }
}

