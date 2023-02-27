//
//  Comic.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import UIKit
import Kingfisher

class ComicTableViewCell: UITableViewCell {

  @IBOutlet private weak var comicLabel: UILabel!
  @IBOutlet private weak var comicImage: UIImageView!
  weak var comicDelegate: ComicDetail?
  private var comicReferance: Comic?
  override func awakeFromNib() {
        super.awakeFromNib()
  }
  func setComicCell(){
    self.comicReferance = comicDelegate?.setComicDetail()
    if let comic = comicReferance {
      comicLabel.text = comic.title
      comicImage.kf.setImage(with: comic.thumbnail?.Url)
    }else{
      fatalError("can't get comics")
    }
  }
}
