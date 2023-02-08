//
//  ViewController.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBOutlet weak var characterTable: UITableView!
  private var characters: RequestBody?
  override func viewDidLoad() {
    super.viewDidLoad()
    characterTable.delegate = self
    characterTable.dataSource = self
    characterTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    Service().downloadCharacters("", page: 0,characterEndpoint: CharacterEndpoint()) { (characters) in
      switch characters {
        case .success(let characters):
          self.characters = characters
          DispatchQueue.main.async {
            self.characterTable.reloadData()
          }
        case .failure(_):
          fatalError("fail")
      }
    }
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = characterTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    var content = cell.defaultContentConfiguration()
    content.text = characters?.data?.results?[indexPath.row].name
    cell.contentConfiguration = content
    
    return cell
  }
}
