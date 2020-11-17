//
//  LogInViewController.swift
//  app
//
//  Created by Sergey Romanenko on 12.11.2020.
//

import UIKit

class LogInViewController: UIViewController{
    let UsernameTextField = appTextField(title: "Enter your username", keyboard: .default)
    let PasswordTextField = appTextField(title: "Enter your password", keyboard: .default)
    let LogInButton = appButton(title: "Log in", background: .systemBlue)
    let DontHaveAccountButton = appButton(title: "Don't have an account?  sign up", background: .systemBlue)
    let ErrorLabel = appLabel(text: "", color: .systemRed, alpha: 0)
    let api = restapi()
    let padding:CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view()
        configure()
        hideKeyboardWhenTappedAround()
    }
    
    func view(){
        view.backgroundColor = .colorBackground
        navigationController?.transparent()
        navigationItem.title = "Log in"
        view.addSubviews(UsernameTextField, PasswordTextField, LogInButton, ErrorLabel, DontHaveAccountButton)
    }
    
    func configure(){
        UsernameTextField.anchor(top: view.safeTopAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 160, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 50)
        
        PasswordTextField.isSecureTextEntry = true
        PasswordTextField.anchor(top: UsernameTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 50)
        
        LogInButton.addTarget(self, action: #selector(load), for: .touchUpInside)
        LogInButton.anchor(top: PasswordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 50)
        
        ErrorLabel.anchor(top: LogInButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 50)
        
        DontHaveAccountButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        DontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 50, paddingRight: padding, width: 0, height: 50)
    }
    
    func validateFields() -> String? {
        if UsernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
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
            upload()
        }
    }
    
    var username:String = ""
    var password:String = ""
    func upload() {
        api.values(.userLogin, ["username":username, "password":password]){result in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(apiDate)
            if let json = try? decoder.decode(actionString.self, from: result) {
                DispatchQueue.main.async{
                    defaults.token = json.values
                    information = json.info
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    self.dismissController()
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
    
    @objc func signup() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc func dismissController(){
        self.dismiss(animated: true, completion: nil)
    }
}
