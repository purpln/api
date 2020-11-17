//
//  Label.swift
//  app
//
//  Created by Sergey Romanenko on 13.11.2020.
//

import UIKit

class appLabel:UILabel{
    override init(frame:CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder:NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text:String, color: UIColor, alpha:CGFloat) {
        self.init(frame: .zero)
        self.text = text
        textColor = color
        self.alpha = alpha
    }
    
    private func configure(){
        textAlignment = .center
        lineBreakMode = .byTruncatingTail
        numberOfLines = 1
        translatesAutoresizingMaskIntoConstraints = false
    }
}
