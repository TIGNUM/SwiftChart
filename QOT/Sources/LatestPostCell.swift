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
    fileprivate var contentCollection = [ContentCollection]()
    fileprivate let helper = Helper()
    weak var delegate: LibraryViewControllerDelegate?

    func setUp(title: String, contentCollection: [ContentCollection]) {
        self.contentCollection = contentCollection
        titleLabel.attributedText = Style.tag(title, .white90).attributedString()
        collectionView.registerDequeueable(LatestCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
}

extension LatestPostCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentCollection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LatestCollectionCell = collectionView.dequeueCell(for: indexPath)
        let collection = contentCollection[indexPath.item]
        cell.setup(headline: collection.title, previewImageURL: collection.thumbnailURL, mediaType: collection.description)

        return cell
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapLibraryItem(item: contentCollection[indexPath.item])
    }
}
