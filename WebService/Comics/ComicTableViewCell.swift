//
//  Comic.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import UIKit

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
      getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async { [weak self] in
          if UIImage(data: data) != nil{
            self?.comicImage.image =  UIImage(data: data)!
          } else {
            self?.comicImage.image = UIImage(named: "notFound")!
          }
        }
      }
  }
  
  func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
}
