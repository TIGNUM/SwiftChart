//
//  CategoryPostCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol CategoryPostCellDataSource {
    //    func itemCount
}

final class CategoryPostCell: UITableViewCell, Dequeueable {
    let viewModel = LibraryViewModel()
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    var itemCount = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(title: String, sectionCount: Int) {
        
        titleLabel.attributedText = AttributedString.Library.categoryTitle(string: title.makingTwoLines())
        
        self.itemCount = sectionCount
        collectionView.registerDequeueable(CategoryCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
}

extension CategoryPostCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.item(at: indexPath)
        
        switch item {
        case .audio ( _, let placeHolderURL, let headline, let text):
            let cell: CategoryCollectionCell = collectionView.dequeueCell(for: indexPath)
            cell.setup(headline: headline, placeholderURL: placeHolderURL, mediaType: text)
            return cell
        case .video( _, let placeHolderURL, let headline, let text):
            let cell: CategoryCollectionCell = collectionView.dequeueCell(for: indexPath)
            cell.setup(headline: headline, placeholderURL: placeHolderURL, mediaType: text)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(self.bounds.height)
        return CGSize(width: 275, height: 180)
    }
}
