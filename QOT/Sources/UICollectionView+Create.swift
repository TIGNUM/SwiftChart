//
//  UICollectionView+Create.swift
//  QOT
//
//  Created by karmic on 31.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {

    convenience init(
        layout: UICollectionViewLayout,        
        contentInsets: UIEdgeInsets = .zero,
        backgroundColor: UIColor = .clear,
        delegate: UICollectionViewDelegate,
        dataSource: UICollectionViewDataSource,
        dequeables: Dequeueable.Type...) {
            self.init(frame: .zero, collectionViewLayout: layout)
            self.backgroundColor = backgroundColor
            self.contentInset = contentInsets
            self.delegate = delegate
            self.dataSource = dataSource
            self.showsVerticalScrollIndicator = false
            self.showsHorizontalScrollIndicator = false
            self.registerDequeueables(dequeables: dequeables)            
    }

    private func registerDequeueables(dequeables: [Dequeueable.Type]) {
        dequeables.forEach { (type) in
            switch type.registration {
            case .nib(let nib):
                register(nib, forCellWithReuseIdentifier: type.reuseID)
            case .class:
                register(type, forCellWithReuseIdentifier: type.reuseID)
            }
        }
    }
}
