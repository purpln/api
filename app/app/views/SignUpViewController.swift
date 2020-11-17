//
//  SignUpViewController.swift
//  app
//
//  Created by Sergey Romanenko on 12.11.2020.
//

import UIKit

class SignUpViewController: UIViewController{
    let EmailTextField = appTextField(title: "Enter email", keyboard: .emailAddress)
    let UsernameTextField = appTextField(title: "Enter username", keyboard: .default)
    let PasswordTextField = appTextField(title: "Enter password", keyboard: .default)
    let SignUpButton = appButton(title: "Sign up", background: .systemBlue)
    let ErrorLabel = appLabel(text: "", color: .systemRed, alpha: 0)
    let api = restapi()
    let padding: CGFloat = 20
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view()
        configure()
        hideKeyboardWhenTappedAround()
    }
    
    func view(){
        view.backgroundColor = .colorBackground
        navigationController?.transparent()
        navigationItem.title = "Registration"
        view.addSubviews(EmailTextField, UsernameTextField, PasswordTextField, SignUpButton, ErrorLabel)
    }
    
    func configure(){
        EmailTextField.anchor(top: view.safeTopAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 160, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 50)
        
        UsernameTextField.anchor(top: EmailTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 50)
        
        PasswordTextField.isSecureTextEntry = true
        PasswordTextField.anchor(top: UsernameTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 50)
        
        SignUpButton.addTarget(self, action: #selector(load), for: .touchUpInside)
        SignUpButton.anchor(top: PasswordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 50)
        
        ErrorLabel.anchor(top: SignUpButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 50)
    }
    
    func validateFields() -> String? {
        if EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            UsernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        return nil
    }
    
    @objc func load() {
        let error = validateFields()
        if error != nil {
            showError(error!)
        }else{
            createSpinnerView()
            password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            username = UsernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            upload()
        }
    }
    
    var username:String = ""
    var password:String = ""
    var email:String = ""
    func upload() {
        api.values(.createUser, ["username":username, "password":password, "email":email]){result in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(apiDate)
            if let json = try? decoder.decode(actionString.self, from: result) {
                DispatchQueue.main.async{
                    self.defaults.set(json.values, forKey:"token")
                    information = json.info
                    self.navigationController?.setViewControllers([SetUpViewController()], animated: true)
                }
            }else if let json = try? decoder.decode(actionError.self, from: result) {
                DispatchQueue.main.async{
                    information = json.info
                    self.showError(information.data)
                }
            }else{
                print(String(data: result, encoding: String.Encoding.utf8)!)
            }
        }
    }
    
    func showError(_ message:String) {
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.ErrorLabel.alpha = 0
        }
    }
}
