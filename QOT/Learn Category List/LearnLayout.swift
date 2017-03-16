//
//  LearnLayout.swift
//  QOT
//
//  Created by tignum on 3/16/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class LearnLayout: UICollectionViewFlowLayout {

        var width: CGFloat = 50.0
        var innerSpace: CGFloat = 10.0
        let numberOfCellsOnRow: CGFloat = 2
        
        override init() {
            super.init()
            self.minimumLineSpacing = innerSpace
            self.minimumInteritemSpacing = innerSpace
            self.scrollDirection = .horizontal
            self.sectionInset = UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10)
            //self.itemSize = CGSize(width: 100, height: 100)
        }
        
        required init?(coder aDecoder: NSCoder) {
            //fatalError("init(coder:) has not been implemented")
            super.init(coder: aDecoder)
        }
        
        func itemWidth() -> CGFloat {
           // innerSpace += innerSpace
            return (collectionView!.frame.size.width/self.numberOfCellsOnRow)-self.innerSpace
        }
        
        override var itemSize: CGSize {
            set {
                self.itemSize = CGSize(width:(itemWidth() * width), height:itemWidth())
            }
            get {
                return CGSize(width:itemWidth(), height:itemWidth())
            }
        }
    }
