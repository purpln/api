//
//  UINavigationController.swift
//  app
//
//  Created by Sergey Romanenko on 14.11.2020.
//

import UIKit

extension UINavigationController{
    func transparent(){
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
}
