//
//  ViewController.swift
//  WebService
//
//  Created by kaan gokcek on 8.02.2023.
//

import UIKit

class CharacterViewController: UIViewController {
  
  private var searchText: String? = ""
  private var isLoading = false// TODO: Buradaki tüm değişkenler private
  private var pageCounter = 0
  private let reloadIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
  private let customView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
  private var requestArray = [Character?]()
  private var characterReferance: Character?
  private var characterDetail = UIStoryboard(name: "CharacterDetailViewController", bundle: nil) //TODO: ismin sonundaXib eklemene gerek yok.
  private let characters = UINib(nibName: "Characters", bundle: nil)
  private let searchController = UISearchController(searchResultsController: nil)
  private let characterLoadingCellNib = UINib(nibName: "LoadingViewCell", bundle: nil)
  private let tableViewHeader = "Marvel Characters"
  @IBOutlet weak var characterTable: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: Boş satırlar silinir.
    setDelegateAndDataSource()
    registerViewControllerItems()
    setActivityIndicator()
    setSearchBarController()
    addMoreContent(searchText)
  }
  func addMoreContent(_ name: String?)  {
    reloadIndicator.startAnimating()
    CharacterService().downloadCharacters(name,page: pageCounter,characterEndpoint: CharacterEndpoint()) { (characters) in
      switch characters {
        case .success(let characters):
        //TODO: Bu tarz bloklarda success veya fail bloklarında yapılacak işlemler uzun ise ayrı bir method altında handle edilmeli. handleMoreContent() gibi bir method altında bu logicleri gerçekleştirebilirsin.
          if let count = characters.data?.results?.count, count != 0{
            if !self.isLoading {
              self.isLoading = true
              if let charactersArray = characters.data?.results{
                self.requestArray.append(contentsOf: charactersArray)
              }
              self.handleMoreContent()
            }
          }else{
            self.stopReloadIndicator()
          }
        case .failure(_):
          fatalError("fail")
      }
    }
  }
  func handleMoreContent(){
    DispatchQueue.main.async {
      self.pageCounter += 1
      self.characterTable.reloadData()
      self.isLoading = false
      self.reloadIndicator.stopAnimating()
      self.reloadIndicator.hidesWhenStopped = true
    }
  }
  func stopReloadIndicator(){
    DispatchQueue.main.async {
      self.reloadIndicator.stopAnimating()
      self.reloadIndicator.hidesWhenStopped = true
    }
  }
  func setDelegateAndDataSource() {
    self.characterTable.delegate = self
    self.characterTable.dataSource = self
  }
  func showDetails() {
    guard let characterDetailViewController = characterDetail.instantiateViewController(identifier: "CharacterDetailViewController") as? CharacterDetailViewController else {
      fatalError("vc not found")
    }
    characterDetailViewController.characterDelegate = self
    navigationController?.pushViewController(characterDetailViewController, animated: true)
  }
  func registerViewControllerItems(){ //TODO: aynı sekilde üst blokta tanımlanmalı.
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
}
// TODO: Boş satırlar silinir.
// TODO: Burada extention eklemen güzel, fakat bunları da bölebilirsin. TableViewProtocollerini ayırıp diger protokolleri de ayrı ayrı extent edebilirsin. (CharacterDetail, UISearchBarDelegate için ayrı extent)
extension CharacterViewController: UISearchBarDelegate{
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchText = ""
    requestArray.removeAll()
    pageCounter = 0
    characterTable.reloadData()
    addMoreContent(searchText)
  }
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchText = searchBar.text
    if searchText != ""{
      requestArray.removeAll()
      pageCounter = 0
      characterTable.reloadData()
      addMoreContent(searchText)
    }
  }
}
extension CharacterViewController: CharacterDetail{
  func setCharacterDetail() -> Character? {
    return characterReferance
  }
}
extension CharacterViewController: UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100

  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == requestArray.count - 1,
        !isLoading{ // TODO: Bu tarz logiclerde yatay mimari değil dikey mimari şeklinde sıralamalısın. Daha okunur olacaktır.
      addMoreContent(searchText)
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
    return tableViewHeader // TODO: String deger bir değişken üzerinden okunmalı.
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.textLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    header.textLabel?.frame = header.bounds
    header.textLabel?.textAlignment = .center
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    self.characterReferance = requestArray[indexPath.row]
    let cell = characterTable.dequeueReusableCell(withIdentifier: "Characters", for: indexPath) as! Characters
    cell.characterDelegate = self
    cell.setCharacterCell()
    return cell
  }
  
}
