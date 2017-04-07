//
//  CategoryPostCell.swift
//  QOT
//
//  Created by tignum on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class CategoryPostCell: UITableViewCell, Dequeueable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp() {
        
    }
}
