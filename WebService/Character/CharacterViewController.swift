//
//  ViewController.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import UIKit

class CharacterViewController: UIViewController {
  
  var isLoading = false
  var pageCounter = 0
  @IBOutlet weak var characterTable: UITableView!
  var requestArray = [Character?]()
  var characterReferance: Character?
  var characterDetailStoryboard = UIStoryboard(name: "CharacterDetailViewControllerXib", bundle: nil)
  let characterLoadingCellNib = UINib(nibName: "LoadingViewCell", bundle: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    characterTable.delegate = self
    characterTable.dataSource = self
    
    self.characterTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    self.characterTable.register(characterLoadingCellNib.self, forCellReuseIdentifier: "loadingCellId")
    
    Task{
      await addMoreContent()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showCharacterDetailViewController" {
      guard let characterDetailViewController = segue.destination as? CharacterDetailViewController else { fatalError("vc not found") }
      characterDetailViewController.characterReferance = self.characterReferance
    }
  }
  
  func addMoreContent() async {
    Service().downloadCharacters(page: pageCounter,characterEndpoint: CharacterEndpoint()) { (characters) in
      switch characters {
        case .success(let characters):
          if !self.isLoading {
            self.isLoading = true
            if let charactersArray = characters.data?.results{
              self.requestArray.append(contentsOf: charactersArray)
            }
            DispatchQueue.main.async {
              self.pageCounter += 1
              self.characterTable.reloadData()
              self.isLoading = false
            }
          }
        case .failure(_):
          fatalError("fail")
      }
    }
  }
}



extension CharacterViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
        return 44 // Item Cell height
    } else {
        return 55 // Loading Cell height
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == requestArray.count - 1, !isLoading{
      Task{
        await addMoreContent()
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return requestArray.count
    } else if section == 1 {
      return 1
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.characterReferance = requestArray[indexPath.row]
    performSegue(withIdentifier: "showCharacterDetailViewController", sender: self)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = characterTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
      var content = cell.defaultContentConfiguration()
      content.text = requestArray[indexPath.row]?.name
      cell.contentConfiguration = content
      return cell
    } else {
      let cell = characterTable.dequeueReusableCell(withIdentifier: "loadingCellId", for: indexPath) as! LoadingViewCell
      cell.reloadIndicator.startAnimating()
      return cell
    }
  }
}
