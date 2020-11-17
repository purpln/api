//
//  UITableCell.swift
//  app
//
//  Created by Sergey Romanenko on 13.11.2020.
//

import UIKit

class TableCell:UITableViewCell{
    let Label = appLabel(text: "", color: .white, alpha: 1)
    let padding:CGFloat = 20
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(Label)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(){
        Label.contentMode = .scaleAspectFit
        Label.clipsToBounds = true
        Label.backgroundColor = .colorGray
        Label.layer.cornerRadius = 20
        Label.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: padding/2, paddingLeft: padding, paddingBottom: padding/2, paddingRight: padding, width: 0, height: 100)
    }
}
