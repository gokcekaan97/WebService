//
//  ViewController.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    Service().downloadCharacters(characterEndpoint: CharacterEndpoint()) { (characters) in
        print(characters)
    }
  }


}

