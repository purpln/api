//
//  TextField.swift
//  app
//
//  Created by Sergey Romanenko on 13.11.2020.
//

import UIKit

class appTextField: UITextField{
    override init(frame:CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder:NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title:String, keyboard:UIKeyboardType){
        self.init(frame: .zero)
        placeholder = title
        keyboardType = keyboard
    }
    
    private func configure(){
        layer.cornerRadius = 15
        textColor = .colorLabel
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        leftViewMode = UITextField.ViewMode.always
        backgroundColor = .colorGray
        autocorrectionType = .no
        returnKeyType = .go
        autocapitalizationType = .none
        clearButtonMode = .whileEditing
        translatesAutoresizingMaskIntoConstraints = false
    }
}
