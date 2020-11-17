//
//  UICollectionLayout.swift
//  app
//
//  Created by Sergey Romanenko on 12.11.2020.
//

import UIKit

class layout:UICollectionViewFlowLayout{
    
    override init(){
        super.init()
        scrollDirection = .vertical
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    func itemWidth() -> CGFloat{
        return collectionView!.frame.size.width/3
    }
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width:itemWidth(), height:itemWidth())
        }
        get {
            return CGSize(width:itemWidth(),height:itemWidth())
        }
    }
    required init?(coder: NSCoder){ fatalError("init(coder:) has not been implemented") }
}
