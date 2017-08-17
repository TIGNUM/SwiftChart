//
//  LibraryTableViewCell.swift
//  QOT
//
//  Created by karmic on 27.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LibraryTableViewCell: UITableViewCell, Dequeueable {

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
        collectionView.registerDequeueable(LibraryCollectionLatestPostCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 160, left: 0, bottom: 0, right: 0)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        collectionView.reloadData()
    }
}   

extension LibraryTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentCollection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if sectionType == .latestPost {
            let cell: LibraryCollectionLatestPostCell = collectionView.dequeueCell(for: indexPath)
            let collection = contentCollection[indexPath.item]
            cell.setup(headline: collection.title, previewImageURL: collection.thumbnailURL, mediaType: collection.description, sectionType: sectionType)
            cell.backgroundColor = .clear

            return cell
        }

        let cell: LibraryCollectionCell = collectionView.dequeueCell(for: indexPath)
        let collection = contentCollection[indexPath.item]
        cell.setup(headline: collection.title, previewImageURL: collection.thumbnailURL, mediaType: collection.description, sectionType: sectionType)
        cell.backgroundColor = .green

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
        return CGSize(width: sectionType.itemWidth, height: sectionType.rowHeight)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee.x = helper.scrollViewScroll(scrollView: scrollView, velocity: velocity, targetContentOffset: targetContentOffset, width: sectionType.itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapLibraryItem(item: contentCollection[indexPath.item])
    }
}
