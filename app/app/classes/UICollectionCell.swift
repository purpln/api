//
//  UICollectionCell.swift
//  app
//
//  Created by Sergey Romanenko on 12.11.2020.
//

import UIKit

class cell:UICollectionViewCell{
    let Label = appLabel(text: "", color: .white, alpha: 1)
    let padding:CGFloat = 5
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubviews(Label)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(){
        Label.contentMode = .scaleAspectFit
        Label.clipsToBounds = true
        Label.backgroundColor = .systemBlue
        let blueView = UIView(frame: bounds)
        blueView.backgroundColor = .colorLabel
        blueView.layer.cornerRadius = 22
        self.selectedBackgroundView = blueView
        Label.layer.cornerRadius = 20
        Label.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: padding, paddingRight: padding, width: 0, height: 0)
    }
}
