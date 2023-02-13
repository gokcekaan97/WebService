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
  let reloadIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
  @IBOutlet weak var characterTable: UITableView!
  var requestArray = [Character?]()
  var characterReferance: Character?
  var characterDetailStoryboard = UIStoryboard(name: "CharacterDetailViewControllerXib", bundle: nil)
  let characters = UINib(nibName: "Characters", bundle: nil)
  let characterLoadingCellNib = UINib(nibName: "LoadingViewCell", bundle: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    characterTable.delegate = self
    characterTable.dataSource = self
    
    self.characterTable.register(characters.self, forCellReuseIdentifier: "Characters")
    self.characterTable.register(characterLoadingCellNib.self, forCellReuseIdentifier: "loadingCellId")
    
    setActivityIndicator()
    
    Task{
      await addMoreContent()
    }
    
  }
  
  func showDetails() {
    guard let characterDetailViewController = characterDetailStoryboard.instantiateViewController(identifier: "CharacterDetailViewController") as? CharacterDetailViewController else {
      fatalError("vc not found")
    }
    characterDetailViewController.characterDelegate = self
    navigationController?.pushViewController(characterDetailViewController, animated: true)
  }
  

  
  func addMoreContent() async {
    reloadIndicator.startAnimating()
    reloadIndicator.backgroundColor = .white
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
              self.reloadIndicator.stopAnimating()
              self.reloadIndicator.hidesWhenStopped = true
            }
          }
        case .failure(_):
          fatalError("fail")
      }
    }
  }
}



extension CharacterViewController: UITableViewDelegate, UITableViewDataSource, CharacterDetail {
  
  func setActivityIndicator(){
    reloadIndicator.style = UIActivityIndicatorView.Style.medium
    reloadIndicator.center = self.view.center
    self.view.addSubview(reloadIndicator)
  }
  
  func setCharacterDetail() -> Character? {
    return characterReferance
  }
  
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return 2
//  }
//
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
//    if indexPath.section == 0 {
//        return 100 // Item Cell height
//    } else {
//        return 55 // Loading Cell height
//    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == requestArray.count - 1, !isLoading{
      
      Task{
        await addMoreContent()
      }
      
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    if section == 0 {
//      return requestArray.count
//    } else if section == 1 {
//      return 1
//    } else {
//      return 0
//    }
    return requestArray.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.characterReferance = requestArray[indexPath.row]
    showDetails()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    if indexPath.section == 0 {
      let cell = characterTable.dequeueReusableCell(withIdentifier: "Characters", for: indexPath) as! Characters
      cell.characterName.text = requestArray[indexPath.row]?.name
      if let characterImage = requestArray[indexPath.row]?.thumbnail?.standardMediumURL{
        cell.downloadImage(from: characterImage)
      }
      
//      var content = cell.defaultContentConfiguration()
//      content.text = requestArray[indexPath.row]?.name
//      cell.contentConfiguration = content
      return cell
//    }
//      else {
//      let cell = characterTable.dequeueReusableCell(withIdentifier: "loadingCellId", for: indexPath) as! LoadingViewCell
//      cell.reloadIndicator.startAnimating()
//      return cell
//    }
  }
  
}
