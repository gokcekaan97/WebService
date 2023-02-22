//
//  ComicDetailViewController.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import UIKit
import Kingfisher

class ComicDetailViewController: UIViewController {
  
  
  @IBOutlet weak var comicImage: UIImageView!
  weak var comicDelegate: ComicDetail?
  var comicReferance: Comic?
  override func viewDidLoad() {
    super.viewDidLoad()
    self.comicReferance = comicDelegate?.setComicDetail()
    
    setComicView()
  }
  
  func setComicView(){
    if let comic = comicReferance {
//      characterNameLabel.text = comic.name
      title = comic.title
      if comic.description != "" {
//        characterDescriptionLabel.text = comic.description
      } else {
//        characterDescriptionLabel.text = "No Description"
      }
//      if let comicComicList = comic.comics?.items {
//        if !comicComicList.isEmpty{
//          characterComicListLabel.text = comicComicList.reduce("") {(result, list) -> String in
//            if let name = list.name{
//              return result + String(describing: "\(name)\n")
//            }
//            return ""
//          }
//        } else {
//          characterComicListLabel.text = "No Comic List"
//        }
//      }
      if let characterImageDetail = comic.thumbnail?.Url{
        comicImage.kf.setImage(with: characterImageDetail)
      }
    } else {
      print("Can't get character")
    }
  }
}
