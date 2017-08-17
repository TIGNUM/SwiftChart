//
//  LibraryTableViewCategoryCell.swift
//  QOT
//
//  Created by karmic on 14.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LibraryTableViewCategoryCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    fileprivate var contentCollection = [ContentCollection]()
    fileprivate var sectionType = SectionType.latestPost
    fileprivate let helper = Helper()
    weak var delegate: LibraryViewControllerDelegate?

    func setUp(title: NSAttributedString, contentCollection: [ContentCollection], sectionType: SectionType) {
        self.contentCollection = contentCollection
        self.sectionType = sectionType
        titleLabel.attributedText = title        
        collectionView.registerDequeueable(LibraryCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        collectionView.reloadData()
    }
}

extension LibraryTableViewCategoryCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentCollection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LibraryCollectionCell = collectionView.dequeueCell(for: indexPath)
        let collection = contentCollection[indexPath.item]
        cell.setup(headline: collection.title, previewImageURL: collection.thumbnailURL, mediaType: collection.items.first?.format, sectionType: sectionType)
        cell.backgroundColor = .clear

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sectionType.itemWidth, height: 195)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee.x = helper.scrollViewScroll(scrollView: scrollView, velocity: velocity, targetContentOffset: targetContentOffset, width: sectionType.itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapLibraryItem(item: contentCollection[indexPath.item])
    }
}
