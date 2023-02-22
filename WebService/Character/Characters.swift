//
//  CharacterDetail.swift
//  WebService
//
//  Created by kaan gokcek on 13.02.2023.
//

import UIKit
import Kingfisher

class Characters: UITableViewCell {

  @IBOutlet weak var characterName: UILabel!
  @IBOutlet weak var characterImage: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
        // Initialization code
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  func downloadImage(from url: URL) {
    characterImage.kf.setImage(with: url)
  }
}
