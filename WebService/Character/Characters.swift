//
//  CharacterDetail.swift
//  WebService
//
//  Created by kaan gokcek on 13.02.2023.
//

import UIKit

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
      getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async { [weak self] in
          if UIImage(data: data) != nil{
            self?.characterImage.image =  UIImage(data: data)!
          } else {
            self?.characterImage.image = UIImage(named: "notFound")!
          }
        }
      }
  }
  
  func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
}
