//
//  LatestPostCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LatestPostCell: UITableViewCell, Dequeueable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    var sectionCount = 0
    let viewModel = LibraryViewModel()
    let helper = Helper()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(title: String, sectionCount: Int) {
        titleLabel.attributedText = AttributedString.Library.latestPostTitle(string: title)
        self.sectionCount = sectionCount
        collectionView.registerDequeueable(LatestCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
}

extension LatestPostCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionCount
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let items = viewModel.item(at: indexPath)
        switch items {
        case .audio ( _, let placeHolderURL, let headline, let text):
            let cell: LatestCollectionCell = collectionView.dequeueCell(for: indexPath)
            cell.setup(headline: headline, placeholderURL: placeHolderURL, mediaType: text)
            return cell
        case .video( _, let placeHolderURL, let headline, let text):
            let cell: LatestCollectionCell = collectionView.dequeueCell(for: indexPath)
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
        return CGSize(width: 220, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee.x = helper.scrollViewScroll(scrollView: scrollView, velocity: velocity, targetContentOffset: targetContentOffset, width: 220)
    }
}
