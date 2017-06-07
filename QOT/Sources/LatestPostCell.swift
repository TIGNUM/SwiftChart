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

    let helper = Helper()
    lazy var mediaItem = LibraryMediaItem.audio(localID: "", placeholderURL: URL(string: "")!, headline: "", text: "")
    var sectionCount = 0

    func setUp(title: String, sectionCount: Int, mediaItem: LibraryMediaItem) {
        self.sectionCount = sectionCount
        self.mediaItem = mediaItem
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
        return sectionCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch mediaItem {
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
