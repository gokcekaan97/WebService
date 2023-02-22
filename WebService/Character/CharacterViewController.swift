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
  let customView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
  var requestArray = [Character?]()
  var characterReferance: Character?
  var characterDetailStoryboard = UIStoryboard(name: "CharacterDetailViewControllerXib", bundle: nil)
  let characters = UINib(nibName: "Characters", bundle: nil)
  let searchController = UISearchController(searchResultsController: nil)
  let characterLoadingCellNib = UINib(nibName: "LoadingViewCell", bundle: nil)
  @IBOutlet weak var characterTable: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setDelegateAndDataSource()
    
    registerViewControllerItems()
    
    setActivityIndicator()
    
    setSearchBarController()
    
    addMoreContent("")
    
  }
  
}



extension CharacterViewController: UITableViewDelegate, UITableViewDataSource, CharacterDetail, UISearchBarDelegate {
  
  func setDelegateAndDataSource() {
    self.characterTable.delegate = self
    self.characterTable.dataSource = self
  }
  

  
  func addMoreContent(_ name: String?)  {
    reloadIndicator.startAnimating()
    CharacterService().downloadCharacters(name,page: pageCounter,characterEndpoint: CharacterEndpoint()) { (characters) in
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
  
  func showDetails() {
    guard let characterDetailViewController = characterDetailStoryboard.instantiateViewController(identifier: "CharacterDetailViewController") as? CharacterDetailViewController else {
      fatalError("vc not found")
    }
    characterDetailViewController.characterDelegate = self
    navigationController?.pushViewController(characterDetailViewController, animated: true)
  }
  
  func registerViewControllerItems(){
    self.characterTable.register(characters.self, forCellReuseIdentifier: "Characters")
    self.characterTable.register(characterLoadingCellNib.self, forCellReuseIdentifier: "loadingCellId")
  }
  
  func setSearchBarController(){
    searchController.searchBar.sizeToFit()
    navigationItem.titleView = searchController.searchBar
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.delegate = self
  }
  
  func setActivityIndicator(){
    reloadIndicator.style = UIActivityIndicatorView.Style.medium
    customView.addSubview(reloadIndicator)
    customView.center = self.view.center
    self.characterTable.tableFooterView = customView
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    requestArray.removeAll()
    pageCounter = 0
    characterTable.reloadData()
    addMoreContent("")
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text, searchBar.text != ""{
      requestArray.removeAll()
      pageCounter = 0
      characterTable.reloadData()
      addMoreContent(searchText)
    }
  }
  
  func setCharacterDetail() -> Character? {
    return characterReferance
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100

  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == requestArray.count - 1, !isLoading, searchController.searchBar.text == ""{
      addMoreContent("")
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return requestArray.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.characterReferance = requestArray[indexPath.row]
    showDetails()
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Marvel Characters"
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.textLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    header.textLabel?.frame = header.bounds
    header.textLabel?.textAlignment = .center
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = characterTable.dequeueReusableCell(withIdentifier: "Characters", for: indexPath) as! Characters
    cell.characterName.text = requestArray[indexPath.row]?.name
    if let characterImage = requestArray[indexPath.row]?.thumbnail?.standardMediumURL{
      cell.downloadImage(from: characterImage)
    }
    return cell
  }
  
}
