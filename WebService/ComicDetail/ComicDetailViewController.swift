//
//  ComicDetailViewController.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import UIKit

class ComicDetailViewController: UIViewController {
  
  
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
//      if let characterImageDetail = character.thumbnail?.landscapeIncredibleURL{
//        downloadImage(from: characterImageDetail)
//      }
    } else {
      print("Can't get character")
    }
  }
  
  func downloadImage(from url: URL) {
      getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async { [weak self] in
//          if UIImage(data: data) != nil{
//              self?.characterThumbnail.image = UIImage(data: data)
//          } else {
//            self?.characterThumbnail.image = UIImage(named: "notFound")
//          }
        }
      }
  }
  
  func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
}
