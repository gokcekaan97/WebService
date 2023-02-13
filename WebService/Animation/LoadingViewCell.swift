//
//  LoadingViewCell.swift
//  WebService
//
//  Created by kaan gokcek on 10.02.2023.
//

import UIKit

class LoadingViewCell: UITableViewCell {

  @IBOutlet weak var reloadIndicator: UIActivityIndicatorView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
