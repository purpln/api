//
//  SetUpColorViewController.swift
//  app
//
//  Created by Sergey Romanenko on 16.11.2020.
//

import UIKit

class SetUpColorViewController:UIViewController{
    let api = restapi()
    let padding: CGFloat = 20
    
    var collectionView:UICollectionView!
    let NextButton = appButton(title: "enter", background: .systemBlue)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view()
        configure()
        hideKeyboardWhenTappedAround()
    }
    
    func view(){
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(cell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.contentInset.bottom = 80
        navigationController?.transparent()
        navigationItem.title = "Choose color"
        view.addSubviews(collectionView, NextButton)
        view.backgroundColor = .colorBackground
    }
    
    func configure(){
        NextButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        NextButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 50, paddingRight: padding, width: 0, height: 50)
        
        collectionView.anchor(top: view.safeTopAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: padding/2, paddingBottom: 0, paddingRight: padding/2, width: 0, height: 0)
    }
    
    @objc func dismissController(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SetUpColorViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! cell
        cell.Label.text = colors[indexPath.row].name
        cell.Label.backgroundColor = UIColor(hex: colors[indexPath.row].hex)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        api.values(.updateValue, ["token":defaults.token, "value":"color", "update":indexPath.row]){result in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(apiDate)
            if let json = try? decoder.decode(actionString.self, from: result) {
                DispatchQueue.main.async{
                    information = json.info
                    print("f")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
            }else if let json = try? decoder.decode(actionError.self, from: result) {
                DispatchQueue.main.async{
                    information = json.info
                    print(information.data)
                    print(String(data: result, encoding: String.Encoding.utf8)!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
            }else{
                print(String(data: result, encoding: String.Encoding.utf8)!)
            }
        }
    }
}
