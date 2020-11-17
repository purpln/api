//
//  View.swift
//  app
//
//  Created by Sergey Romanenko on 14.11.2020.
//

import UIKit

class appView:UIView{
    let Label = UILabel()
    let Description = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
        addSubviews(Label, Description)
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(label:String, description:String){
        self.init(frame: .zero)
        Label.text = label
        Description.text = description
    }
    
    private func configure() {
        super.layoutSubviews()
        Label.frame = bounds
        backgroundColor = .colorGray
        layer.cornerRadius = 15
        translatesAutoresizingMaskIntoConstraints = false
    }
}
