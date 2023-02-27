//
//  ComicDetailViewController.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import UIKit
import Kingfisher

class ComicDetailViewController: UIViewController {
    
  @IBOutlet private weak var comicImage: UIImageView!
  weak var comicDelegate: ComicDetail?
  private var comicReferance: Comic?
  // TODO: Edit:: comicReferance sadece bu class da kullanılacaksa private olarak tanımlanabilir. Bu sekilde tüm class lardan görünür ve bellekte fazla yer kaplar.
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.comicReferance = comicDelegate?.setComicDetail()
    setComicView()
  }
  // TODO: Edit:: Burada kullanılmayan satırları silebilirsin.
  func setComicView(){
    if let comic = comicReferance {
      title = comic.title
      if let characterImageDetail = comic.thumbnail?.Url{
        comicImage.kf.setImage(with: characterImageDetail)
      }
    } else {
      fatalError("Can't get character")  // TODO: Edit:: Kod içerisinde print kullanıabilirsin ama projeye en son commit olarak atma. Eger atmak gerekiyorsa print yerine debugPrint kullanmalısın.
    }
  }
}
