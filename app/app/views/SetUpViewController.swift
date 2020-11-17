//
//  SetUpViewController.swift
//  app
//
//  Created by Sergey Romanenko on 16.11.2020.
//

import UIKit

class SetUpViewController: UIViewController, UITextFieldDelegate{
    let api = restapi()
    let padding: CGFloat = 20
    
    let NameTextField = appTextField(title: "Your name", keyboard: .default)
    let UploadButton = appButton(title: "Enter", background: .systemBlue)
    let ErrorLabel = appLabel(text: "", color: .colorLabel, alpha: 0)
    let NextButton = appButton(title: "Next", background: .systemBlue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view()
        configure()
        hideKeyboardWhenTappedAround()
    }
    
    func view(){
        view.backgroundColor = .colorBackground
        navigationController?.transparent()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "skip", style: .plain, target: self, action: #selector(dismissController))
        navigationItem.title = "Enter name"
        view.addSubviews(NameTextField, UploadButton, ErrorLabel, NextButton)
    }
    
    func configure(){
        NameTextField.delegate = self
        NameTextField.anchor(top: view.safeTopAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        UploadButton.addTarget(self, action: #selector(load), for: .touchUpInside)
        UploadButton.anchor(top: view.safeTopAnchor, left: NameTextField.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 80, height: 50)
        
        ErrorLabel.anchor(top: UploadButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 50)
        
        NextButton.addTarget(self, action: #selector(nextController), for: .touchUpInside)
        NextButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 50, paddingRight: padding, width: 0, height: 50)
    }
    
    var name:String = ""
    @objc func load(){
        name = NameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        api.values(.updateValue, ["token":defaults.token, "value":"name", "update":name]){result in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(apiDate)
            if let json = try? decoder.decode(actionString.self, from: result) {
                DispatchQueue.main.async{
                    information = json.info
                    self.showError(information.data, information.error)
                }
            }else if let json = try? decoder.decode(actionError.self, from: result) {
                DispatchQueue.main.async{
                    information = json.info
                    self.showError(information.data, information.error)
                }
            }else{
                print(String(data: result, encoding: String.Encoding.utf8)!)
            }
        }
    }
    
    @objc func nextController() {
        navigationController?.pushViewController(SetUpColorViewController(), animated: true)
    }
    
    func showError(_ message:String, _ error:Bool){
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
        if error {
            ErrorLabel.textColor = .systemRed
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.ErrorLabel.alpha = 0
        }
    }
    
    @objc func dismissController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        load()
        self.view.endEditing(true)
        return false
    }
}
