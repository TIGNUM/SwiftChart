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
    let helper = Helper()

    override func awakeFromNib() {
        super.awakeFromNib()


    }
    
    func setUp(title: String, itemCount: Int) {
        
        titleLabel.attributedText = AttributedString.Library.categoryTitle(string: title.makingTwoLines())
        
        self.itemCount = itemCount
        collectionView.registerDequeueable(CategoryCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(self.bounds.height)
        return CGSize(width: 275, height: collectionView.frame.height)
    }


    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee.x = self.helper.scrollViewScroll(scrollView: scrollView, velocity: velocity, targetContentOffset: targetContentOffset, width: 275)
    }
}
