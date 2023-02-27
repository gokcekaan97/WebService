//
//  CharacterDetail.swift
//  WebService
//
//  Created by kaan gokcek on 13.02.2023.
//

import UIKit
import Kingfisher

class Characters: UITableViewCell {

  @IBOutlet private weak var characterName: UILabel! //TODO: private
  @IBOutlet private weak var characterImage: UIImageView!
  weak var characterDelegate: CharacterDetail?
  private var characterReferance: Character?
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  func setCharacterCell(){
    self.characterReferance = characterDelegate?.setCharacterDetail()
    if let character = characterReferance {
      characterName.text = character.name
      characterImage.kf.setImage(with: character.thumbnail?.Url)
    }else{
      fatalError("can't get comics")
    }
  }
}
