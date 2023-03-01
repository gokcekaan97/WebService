//
//  ComicsViewController.swift
//  WebService
//
//  Created by kaan gokcek on 16.02.2023.
//

import UIKit

class ComicsViewController: UIViewController {

  //TODO: Burayla ilgili benzer sayfalarda yaptıgım yorumların aynıları buralarda da mevcut. Burayı da handle edelim.
  private var searchText: String? = ""
  private var isLoading = false
  private var pageCounter = 0
  private var headerString = "Marvel Comics"
  private var selectedFilter = 0
  private let searchController = UISearchController(searchResultsController: nil)
  private let reloadIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
  private let customView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
  private var requestArray = [Comic?]()
  private var comicReferance: Comic?
  private let comicTableViewCell = UINib(nibName: "ComicTableViewCell", bundle: nil)
  private let loadingCellNib = UINib(nibName: "LoadingViewCell", bundle: nil)
  private var main = UIStoryboard(name: "Main", bundle: nil)
  private var comicDetail = UIStoryboard(name: "ComicDetailStoryboard", bundle: nil)
  private let filterPickerView = ["Default","Ascending Title","Descenging Title","Ascending On Sale Date","Descending On Sale Date"]
  private let filterPickerServiceName = ["","title","-title","onsaleDate","-onsaleDate"]
  private var pickerView: UIPickerView!
  private var filterView: UIView!
  private var backButton: UIButton!
  @IBOutlet private weak var comicTable: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    //TODO: Boşluklar
    setBackButton()
    setDataSourceAndDelegate()
    registerViewControllerItems()
    setActivityIndicator()
    setSearchBarController()
    setPickerView()
    addMoreContent(searchText)
  }
  func setBackButton(){
    backButton = UIButton(type: .custom)
    backButton.setImage(UIImage(named: "BackButton.png"), for: .normal)
    backButton.setTitle("Back", for: .normal)
    backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
    backButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
    backButton.isHidden = true
  }
  @objc func backAction() -> Void {
    self.navigationItem.leftBarButtonItem = nil
    searchController.searchBar.isHidden = false
    backButton.isHidden = true
    self.dismiss(animated: true)
  }
  func setDataSourceAndDelegate(){
    comicTable.delegate = self
    comicTable.dataSource = self
  }
  func showDetails() {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    if searchController.isActive{
      self.searchController.dismiss(animated: true){
        self.showMoreDetails()
      }
    } else {
      showMoreDetails()
    }
  }
  func showMoreDetails(){
    guard let comicDetailViewController = comicDetail.instantiateViewController(identifier: "ComicDetailViewController") as? ComicDetailViewController else {
      fatalError("vc not found")
    }
    searchController.searchBar.isHidden = true
    backButton.isHidden = false
    self.definesPresentationContext = true
    comicDetailViewController.comicDelegate = self
    comicDetailViewController.modalPresentationStyle = .overCurrentContext
    self.present(comicDetailViewController, animated: true, completion: nil)
  }
  func setPickerView(){
    filterView = UIView(frame: CGRect(x: 0, y: self.view.bounds.height, width: view.frame.width, height: 44))
    filterView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(filterView)
    pickerView = UIPickerView.init()
    let pickerViewToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction(_:)))
    pickerViewToolbar.sizeToFit()
    pickerViewToolbar.setItems([spaceButton, doneButton], animated: true)
    pickerViewToolbar.isUserInteractionEnabled = true
    pickerView.sizeToFit()
    pickerView.isUserInteractionEnabled = true
    pickerView.backgroundColor = UIColor.white
    pickerView.setValue(UIColor.black, forKey: "textColor")
    pickerView.autoresizingMask = .flexibleWidth
    pickerView.contentMode = .center
    pickerView.frame = CGRect.init(x: 0.0, y: self.view.bounds.height , width: view.frame.width, height: 220)
    self.filterView.addSubview(pickerViewToolbar)
    pickerView.delegate = self
    pickerView.dataSource = self
    self.view.addSubview(pickerView)
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
    searchController.searchBar.showsBookmarkButton = true
    searchController.searchBar.setImage(UIImage(systemName: "list.bullet"), for: .bookmark, state: .normal)
    searchController.searchBar.searchTextField.clearButtonMode = .never
  }
  func setActivityIndicator(){
    reloadIndicator.style = UIActivityIndicatorView.Style.medium
    customView.addSubview(reloadIndicator)
    customView.center = self.view.center
    self.comicTable.tableFooterView = customView
  }
  func addMoreContent(_ name: String?)  {
    reloadIndicator.startAnimating()
    ComicService().downloadComics(filterPickerServiceName[selectedFilter],name,page: pageCounter,comicEndpoint: ComicEndpoint()) { (comics) in
      switch comics {
        case .success(let comics):
          if let count = comics.data?.results?.count, count != 0{
            if !self.isLoading {
              self.isLoading = true
//              if let status = comics.status{
//                print(status)
//              }
              if let comicsArray = comics.data?.results{
                self.requestArray.append(contentsOf: comicsArray)
              }
              self.handleMoreContent()
            }
          } else {
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
      self.comicTable.reloadData()
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
  @objc func doneButtonAction(_ sender: UIBarButtonItem){
    disappearPickerView()
    requestArray.removeAll()
    pageCounter = 0
    comicTable.reloadData()
    addMoreContent(searchText)
  }
  func appearPickerView() {
    UIPickerView.animate(withDuration: 0.3, animations: {
      self.pickerView.frame = CGRect(x: 0, y: self.view.bounds.height - 300, width:      self.filterView.bounds.size.width, height:      self.pickerView.bounds.size.height)
      })
    UIView.animate(withDuration: 0.3, animations: {
      self.filterView.frame = CGRect(x: 0, y: self.view.bounds.height - 344, width:      self.filterView.bounds.size.width, height:      self.filterView.bounds.size.height)
      })
  }
  func disappearPickerView() {
    UIPickerView.animate(withDuration: 0.3, animations: {
        self.pickerView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.filterView.bounds.size.width, height: self.pickerView.bounds.size.height)
    })
      UIView.animate(withDuration: 0.3, animations: {
          self.filterView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.filterView.bounds.size.width, height: self.filterView.bounds.size.height)
      })
  }
  @objc func dismissView(){
    guard let comicDetailViewController = comicDetail.instantiateViewController(identifier: "ComicDetailViewController") as? ComicDetailViewController else {
      fatalError("vc not found")
    }
    comicDetailViewController.dismiss(animated: true)
  }
}

extension ComicsViewController: UISearchBarDelegate{
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchText = ""
    requestArray.removeAll()
    pageCounter = 0
    comicTable.reloadData()
    addMoreContent(searchText)
  }
  
  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    appearPickerView()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchText = searchBar.text
    if searchBar.text != ""{
      requestArray.removeAll()
      pageCounter = 0
      comicTable.reloadData()
      addMoreContent(searchText)
    }
  }
}

extension ComicsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    filterPickerView.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return filterPickerView[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedFilter = row
  }
}

extension ComicsViewController: ComicDetail{
  func setComicDetail() -> Comic? {
    return comicReferance
  }
}

extension ComicsViewController: UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100

  }
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == requestArray.count - 1,
    !isLoading{
      addMoreContent(searchText)
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
    return headerString
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.textLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    header.textLabel?.frame = header.bounds
    header.textLabel?.textAlignment = .center
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    self.comicReferance = requestArray[indexPath.row]
    let cell = comicTable.dequeueReusableCell(withIdentifier: "comicTableViewCell", for: indexPath) as! ComicTableViewCell
    cell.comicDelegate = self
    cell.setComicCell()
    return cell
  }
}
