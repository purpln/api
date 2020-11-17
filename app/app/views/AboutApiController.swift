//
//  AboutApiController.swift
//  app
//
//  Created by Sergey Romanenko on 13.11.2020.
//

import UIKit

class AboutApiController: UIViewController{
    let label0 = UILabel()
    let label1 = UILabel()
    let label2 = UILabel()
    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorBackground
        view.addSubviews(label0, label1, label2)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(dismissController))
        navigationItem.rightBarButtonItem?.tintColor = .colorLabel
        navigationController?.transparent()
        configure()
    }
    
    func configure(){
        label0.text = "\(information.api), v\(information.version), \(information.description)"
        label1.text = "error: \(information.error), \(information.data)"
        label2.text = "last operation seed: \(information.seed)"
        label0.anchor(top: view.safeTopAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        label1.anchor(top: label0.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        label2.anchor(top: label1.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
    }
    
    @objc func dismissController(){
        self.dismiss(animated: true, completion: nil)
    }
}
