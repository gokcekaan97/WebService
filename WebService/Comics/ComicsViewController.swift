//
//  ComicsViewController.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import UIKit

class ComicsViewController: UIViewController {

  var isLoading = false
  var pageCounter = 0
  let searchController = UISearchController(searchResultsController: nil)
  let reloadIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
  let customView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
  var requestArray = [Comic?]()
  var comicReferance: Comic?
  let comicTableViewCell = UINib(nibName: "ComicTableViewCell", bundle: nil)
  let loadingCellNib = UINib(nibName: "LoadingViewCell", bundle: nil)
  var comicDetailStoryboard = UIStoryboard(name: "ComicDetailStoryboard", bundle: nil)
  @IBOutlet weak var comicTable: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    comicTable.delegate = self
    comicTable.dataSource = self
    
    registerViewControllerItems()
    
    setActivityIndicator()
    
    setSearchBarController()
    
    addMoreContent("")
    
  }

}

extension ComicsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ComicDetail {
  
  func addMoreContent(_ name: String?)  {
    reloadIndicator.startAnimating()
    ComicService().downloadComics(name,page: pageCounter,characterEndpoint: ComicEndpoint()) { (comics) in
      switch comics {
        case .success(let comics):
          if !self.isLoading {
            self.isLoading = true
            if let comicsArray = comics.data?.results{
              self.requestArray.append(contentsOf: comicsArray)
            }
            DispatchQueue.main.async {
              self.pageCounter += 1
              self.comicTable.reloadData()
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
    guard let comicDetailViewController = comicDetailStoryboard.instantiateViewController(identifier: "ComicDetailViewController") as? ComicDetailViewController else {
      fatalError("vc not found")
    }
    comicDetailViewController.comicDelegate = self
    navigationController?.pushViewController(comicDetailViewController, animated: true)
  }
  
  func registerViewControllerItems(){
    self.comicTable.register(comicTableViewCell.self, forCellReuseIdentifier: "comicTableViewCell")
    self.comicTable.register(loadingCellNib.self, forCellReuseIdentifier: "loadingCellId")
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
    self.comicTable.tableFooterView = customView
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    requestArray.removeAll()
    pageCounter = 0
    comicTable.reloadData()
    addMoreContent("")
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text, searchBar.text != ""{
      requestArray.removeAll()
      pageCounter = 0
      comicTable.reloadData()
      addMoreContent(searchText)
    }
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
  }
  
  func setComicDetail() -> Comic? {
    return comicReferance
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
    self.comicReferance = requestArray[indexPath.row]
    showDetails()
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Marvel Comics"
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.textLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    header.textLabel?.frame = header.bounds
    header.textLabel?.textAlignment = .center
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = comicTable.dequeueReusableCell(withIdentifier: "comicTableViewCell", for: indexPath) as! ComicTableViewCell
    cell.comicLabel.text = requestArray[indexPath.row]?.title
    if let characterImage = requestArray[indexPath.row]?.thumbnail?.Url{
      cell.downloadImage(from: characterImage)
    }
    return cell
  }
}
