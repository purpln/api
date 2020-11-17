//
//  UIColor.swift
//  app
//
//  Created by Sergey Romanenko on 14.11.2020.
//

import UIKit

extension UIColor {
    convenience init?(hex: String){
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count{
        case 3: (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xf) * 17, (int & 0xf) * 17, 0xff)
        case 4: (r, g, b, a) = (int >> 12, int >> 8 & 0xff, int >> 4 & 0xff, int & 0xff)
        case 6: (r, g, b, a) = (int >> 16, int >> 8 & 0xff, int & 0xff, 0xff)
        case 8: (r, g, b, a) = (int >> 24 & 0xff, int >> 16 & 0xff, int >> 8 & 0xff, int & 0xff)
        default:(r, g, b, a) = (1, 1, 1, 1)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue:  CGFloat(b) / 255, alpha: CGFloat(a) / 255 )
        return
    }
    
    public class var colorBackground:UIColor{
        if #available(iOS 13.0, *) {
            return .systemBackground
        }
        return .white
    }
    
    public class var colorLabel:UIColor{
        if #available(iOS 13.0, *) {
            return .label
        }
        return .black
    }
    
    public class var colorGray:UIColor{
        if #available(iOS 13.0, *) {
            return .systemGray5
        }
        return UIColor(red: 229, green: 229, blue: 234, alpha: 1)
    }
}
