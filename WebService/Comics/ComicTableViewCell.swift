//
//  Comic.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import UIKit
import Kingfisher

class ComicTableViewCell: UITableViewCell {

  @IBOutlet weak var comicLabel: UILabel!
  @IBOutlet weak var comicImage: UIImageView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func downloadImage(from url: URL) {
    comicImage.kf.setImage(with: url)
  }
}
