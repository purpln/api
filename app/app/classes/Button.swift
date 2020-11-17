//
//  Button.swift
//  app
//
//  Created by Sergey Romanenko on 12.11.2020.
//

import UIKit

class appButton:UIButton{
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, background: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = background
        setTitle(title, for: .normal)
    }
    
    private func configure(){
        layer.cornerRadius = 15
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
    func set(backgroundColor: UIColor, title: String){
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
