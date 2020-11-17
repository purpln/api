//
//  DetailController.swift
//  app
//
//  Created by Sergey Romanenko on 12.11.2020.
//

import UIKit

class DetailController: UIViewController{
    var tableView:UITableView!
    let refreshControl = UIRefreshControl(frame: CGRect.zero)
    let api = restapi()
    var results:[type] = []
    var username:String = ""
    var navigationTitle:String = "detail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view()
        configure()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        if UIDevice.current.userInterfaceIdiom == .pad{
            if let splitController = splitViewController{
                if let navController = splitController.viewControllers.last as? UINavigationController{
                    navController.topViewController?.navigationItem.leftBarButtonItem = splitController.displayModeButtonItem
                }
            }
        }
    }
    
    func view(){
        hideKeyboardWhenTappedAround()
        navigationItem.title = navigationTitle
        tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.refreshControl = refreshControl
        tableView.register(TableCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.separatorStyle = .none
        view.addSubviews(tableView)
        view.backgroundColor = .colorBackground
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }
    
    func configure(){
        
    }
    
    @objc func refresh(sender: UIRefreshControl){
        sender.beginRefreshing()
        load()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            sender.endRefreshing()
        })
    }
    
    func load(){
        api.values(.getUserByUsername, ["token":defaults.token, "username":username]){ result in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(apiDate)
            if let json = try? decoder.decode(actionUserByUsername.self, from: result) {
                DispatchQueue.main.async{
                    information = json.info
                    self.results.removeAll()
                    self.results.append(type(type: .id, string: String(json.values.id)))
                    self.results.append(type(type: .email, string: json.values.email))
                    self.results.append(type(type: .name, string: json.values.name))
                    self.results.append(type(type: .rank, string: json.values.rank))
                    self.results.append(type(type: .color, string: String(json.values.color)))
                    self.results.append(type(type: .date, string: current(json.values.date.current() ) ))
                    self.results.append(type(type: .last, string: current(json.values.last.current() ) ))
                    self.results.append(type(type: .photo, string: json.values.photo))
                    self.tableView.reloadData()
                }
            }else if let json = try? decoder.decode(actionError.self, from: result) {
                DispatchQueue.main.async{
                    information = json.info
                    print(json.info)
                }
            }else{
                print(String(data: result, encoding: String.Encoding.utf8)!)
            }
        }
    }
    
    struct type{
        var type:type
        var string:String
        
        enum type{
            case id
            case username
            case email
            case name
            case rank
            case color
            case date
            case last
            case photo
        }
    }
}

extension DetailController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableCell
        cell.Label.textColor = .colorLabel
        switch results[indexPath.row].type{
        case .id: cell.Label.text = "id: \(results[indexPath.row].string)"
        case .username: cell.Label.text = "username: \(results[indexPath.row].string)"
        case .email: cell.Label.text = "email: \(results[indexPath.row].string)"
        case .name: cell.Label.text = "name: \(results[indexPath.row].string)"
        case .rank: cell.Label.text = "rank: \(results[indexPath.row].string)"
        case .color: cell.Label.backgroundColor = UIColor(hex: colors[Int(results[indexPath.row].string)!].hex)
        case .date: cell.Label.text = "registration date: \(results[indexPath.row].string)"
        case .last: cell.Label.text = "was online: \(results[indexPath.row].string)"
        case .photo: cell.Label.text = "photo: \(results[indexPath.row].string)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        
    }
}
