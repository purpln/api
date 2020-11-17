//
//  UIView.swift
//  app
//
//  Created by Sergey Romanenko on 14.11.2020.
//

import UIKit

extension UIView{
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true}
        if let left = left {self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true}
        if let bottom = bottom {bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true}
        if let right = right{rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true}
        if width != 0{widthAnchor.constraint(equalToConstant: width).isActive = true}
        if height != 0{ heightAnchor.constraint(equalToConstant: height).isActive = true}
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
}
