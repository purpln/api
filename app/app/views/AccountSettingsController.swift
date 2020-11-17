//
//  AccountSettingsController.swift
//  app
//
//  Created by Sergey Romanenko on 12.11.2020.
//

import UIKit

class AccountSettingsController: UIViewController{
    var tableView:UITableView!
    let refreshControl = UIRefreshControl(frame: CGRect.zero)
    let Label = appLabel(text: defaults.token, color: .systemBlue, alpha: 1)
    let api = restapi()
    let padding: CGFloat = 20
    var results:[type] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        view()
    }
    
    func view(){
        hideKeyboardWhenTappedAround()
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
        NotificationCenter.default.addObserver(self, selector: #selector(load), name: NSNotification.Name(rawValue: "load"), object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissController))
        navigationItem.rightBarButtonItem?.tintColor = .colorLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "About api", style: .plain, target: self, action: #selector(about))
        navigationItem.leftBarButtonItem?.tintColor = .colorLabel
        navigationController?.transparent()
        UINavigationBar.appearance().barTintColor = .colorBackground
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.anchor(top: view.safeTopAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func refresh(sender: UIRefreshControl){
        sender.beginRefreshing()
        load()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            sender.endRefreshing()
        })
    }
    
    @objc func load(){
        api.value(.getUserByToken, defaults.token){result in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(apiDate)
            if let json = try? decoder.decode(actionUserByToken.self, from: result) {
                DispatchQueue.main.async{
                    information = json.info
                    self.results.removeAll()
                    self.results.append(type(type: .id, string: String(json.values.id)))
                    self.results.append(type(type: .username, string: json.values.username))
                    self.results.append(type(type: .password, string: json.values.password))
                    self.results.append(type(type: .email, string: json.values.email))
                    self.results.append(type(type: .name, string: json.values.name))
                    self.results.append(type(type: .rank, string: json.values.rank))
                    self.results.append(type(type: .token, string: json.values.token))
                    self.results.append(type(type: .color, string: String(json.values.color)))
                    self.results.append(type(type: .date, string: current(json.values.date.current() ) ))
                    self.results.append(type(type: .last, string: current(json.values.last.current() ) ))
                    self.results.append(type(type: .photo, string: json.values.photo))
                    self.tableView.reloadData()
                }
            }else if let json = try? decoder.decode(actionError.self, from: result) {
                DispatchQueue.main.async{
                    information = json.info
                    self.tableView.reloadData()
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
            case id, username, password, email, name, rank, token, color, date, last, photo
        }
    }
    
    @objc func about() {
        let controller = UINavigationController(rootViewController: AboutApiController())
        present(controller, animated: true)
    }
    
    @objc func dismissController(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension AccountSettingsController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case self.tableView:
            return results.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableCell
        cell.Label.textColor = .colorLabel
        switch results[indexPath.row].type{
        case .id: cell.Label.text = "id: \(results[indexPath.row].string)"
        case .username: cell.Label.text = "username: \(results[indexPath.row].string)"
        case .password: cell.Label.text = "password: \(results[indexPath.row].string)"
        case .email: cell.Label.text = "email: \(results[indexPath.row].string)"
        case .name: cell.Label.text = "name: \(results[indexPath.row].string)"
        case .rank: cell.Label.text = "rank: \(results[indexPath.row].string)"
        case .token: cell.Label.text = "token: \(results[indexPath.row].string)"
        case .color:
            cell.Label.text = ""
            cell.Label.backgroundColor = UIColor(hex: colors[Int(results[indexPath.row].string)!].hex)
        case .date: cell.Label.text = "registration date: \(results[indexPath.row].string)"
        case .last: cell.Label.text = "was online: \(results[indexPath.row].string)"
        case .photo: cell.Label.text = "photo: \(results[indexPath.row].string)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        switch results[indexPath.row].type{
        case .color: navigationController?.pushViewController(SetUpColorViewController(), animated: true)
        case .name: navigationController?.pushViewController(SetUpNameViewController(), animated: true)
        case .id, .username, .password, .email, .rank, .token, .date, .last, .photo: print()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        
    }
}

