//
//  MasterController.swift
//  app
//
//  Created by Sergey Romanenko on 12.11.2020.
//

import UIKit

class MasterController: UIViewController{
    var collectionView:UICollectionView!
    var searchController:UISearchController!
    let refreshControl = UIRefreshControl(frame: CGRect.zero)
    var filtered:[actionListUsers.values] = []
    var results:[actionListUsers.values] = []
    var api = restapi()
    let padding:CGFloat = 20
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        if auth(){
            load()
        }
        loadColors()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(load), name: NSNotification.Name(rawValue: "load"), object: nil)
        view()
        hideKeyboardWhenTappedAround()
    }
    
    func view(){
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(cell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
        collectionView.contentInset.bottom = 80
        view.addSubviews(collectionView)
        view.backgroundColor = .colorBackground
        navigationItem.title = "app"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "log out", style: .plain, target: self, action: #selector(handleSignOut))
        navigationItem.rightBarButtonItem?.tintColor = .colorLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "account", style: .plain, target: self, action: #selector(presentAccountSettings))
        navigationItem.leftBarButtonItem?.tintColor = .colorLabel
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["all", "user", "admin", "other"]
        searchController.searchBar.delegate = self
        if #available(iOS 11.0, *){
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        }
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.isTranslucent = false
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }
    
    @objc func refresh(sender: UIRefreshControl){
        sender.beginRefreshing()
        if auth(){
            load()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            sender.endRefreshing()
        })
        collectionView.bringSubviewToFront(collectionView.refreshControl!)
    }
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: "Are you sure you want to sign out?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.logOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true)
    }
    
    @objc func load(){
        api.value(.listUsers, userToken()){result in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(apiDate)
            if let json = try? decoder.decode(actionListUsers.self, from: result) {
                DispatchQueue.main.async{
                    self.results = json.values
                    information = json.info
                    self.collectionView.reloadData()
                }
            }else if let json = try? decoder.decode(actionError.self, from: result) {
                DispatchQueue.main.async{
                    information = json.info
                    self.collectionView.reloadData()
                }
            }else{
                print(String(data: result, encoding: String.Encoding.utf8)!)
            }
        }
    }
    
    func auth()->Bool{
        if userToken() == ""{
            let controller = UINavigationController(rootViewController: LogInViewController())
            if #available(iOS 13.0, *) {
                controller.isModalInPresentation = true
            }
            present(controller, animated: true)
            return false
        }
        return true
    }
    
    func loadColors(){
        if colors.count == 0{
            api.value(.colors, "."){result in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(apiDate)
                if let json = try? decoder.decode(actionColors.self, from: result) {
                    DispatchQueue.main.async{
                        colors = json.values
                        information = json.info
                        self.load()
                    }
                }else if let json = try? decoder.decode(actionError.self, from: result) {
                    DispatchQueue.main.async{
                        print(String(data: result, encoding: String.Encoding.utf8)!)
                        information = json.info
                    }
                }else{
                    print(String(data: result, encoding: String.Encoding.utf8)!)
                }
            }
        }
    }
    
    func logOut(){
        self.defaults.set(nil, forKey:"token")
        if auth(){
            load()
        }
    }
    
    @objc func presentAccountSettings(){
        let controller = UINavigationController(rootViewController: AccountSettingsController())
        present(controller, animated: true)
    }
}

extension MasterController:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.isActive {
            return filtered.count
        }
        return results.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! cell
        let search:actionListUsers.values
        if searchController.isActive {
            search = filtered[indexPath.row]
        } else {
            search = results[indexPath.row]
        }
        cell.Label.backgroundColor = UIColor(hex: colors[Int(search.color) ?? 0].hex)
        cell.Label.text = search.username
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let search: actionListUsers.values
        if searchController.isActive {
            search = filtered[indexPath.row]
        } else {
            search = results[indexPath.row]
        }
        let controller = DetailController()
        controller.navigationTitle = search.username
        controller.username = search.username
        controller.load()
        let navigationController = UINavigationController(rootViewController: controller)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
    }
}

extension MasterController:UISearchResultsUpdating, UISearchBarDelegate{
    func filterContentForSearchText(_ searchText: String, scope: String = "all") {
        filtered = results.filter { result in
            if !(result.rank == scope) && scope != "all" {
                return false
            }
            
            return result.username.lowercased().contains(searchText.lowercased()) || searchText == ""
        }
        
        collectionView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
