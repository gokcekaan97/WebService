//
//  ViewController.swift
//  WebService
//
//  Created by kaan gokcek on 10.02.2023.
//

import UIKit
import Kingfisher

class CharacterDetailViewController: UIViewController {
  
  @IBOutlet private weak var characterThumbnail: UIImageView!// TODO: Boş satırlar silinir.
  @IBOutlet private weak var characterComicListLabel: UILabel!// TODO: Boş satırlar silinir.
  @IBOutlet private weak var characterDescriptionLabel: UILabel!// TODO: Boş satırlar silinir.
  @IBOutlet private weak var characterNameLabel: UILabel!// TODO: Boş satırlar silinir.
  private var characterReferance: Character?  // TODO: Private
  weak var characterDelegate: CharacterDetail? // TODO: Boş satırlar silinir.
  override func viewDidLoad() {
    super.viewDidLoad()
    self.characterReferance = characterDelegate?.setCharacterDetail()
    setCharacterView()
    // TODO: Boş satırlar silinir.
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
      fatalError("Can't get character") // TODO: DebugPrint Kullanılmayacaksa else blogu silinebilir.
    }
  }
}

