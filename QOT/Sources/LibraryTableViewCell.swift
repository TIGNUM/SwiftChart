//
//  LibraryTableViewCell.swift
//  QOT
//
//  Created by karmic on 27.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LibraryTableViewCell: UITableViewCell, Dequeueable {

    enum CollectionViewCellType: String {
        case latestPost = "LibraryLatestPostCollectionViewCell"
        case category = "LibraryCategoryCollectionViewCell"

        var size: CGSize {
            switch self {
            case .latestPost:
                return CGSize(width: 219.0, height: 220.0)
            case .category:
                return CGSize(width: 272.0, height: 170.0)
            }
        }
    }

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    private var contentCollection = [ContentCollection]()
    private var collectionViewCellSize: CGSize!
    private var collectionViewCellType: CollectionViewCellType!
    weak var delegate: LibraryViewControllerDelegate!

    func setUp(delegate: LibraryViewControllerDelegate?, title: NSAttributedString, contentCollection: [ContentCollection], collectionViewCellType: CollectionViewCellType) {
        self.delegate = delegate
        titleLabel.attributedText = title
        self.contentCollection = contentCollection
        self.collectionViewCellType = collectionViewCellType

        contentView.backgroundColor = .clear
        backgroundColor = .clear
        collectionView.register(
            UINib(nibName: collectionViewCellType.rawValue, bundle: nil),
            forCellWithReuseIdentifier: collectionViewCellType.rawValue
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.reloadData()

        collectionViewHeightConstraint.constant = collectionViewCellType.size.height
        layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource

extension LibraryTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentCollection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellType.rawValue, for: indexPath) as? LibraryCollectionViewCell else {
            fatalError("missing xib with name \(collectionViewCellType.rawValue)")
        }
        let collection = contentCollection[indexPath.item]
        cell.setup(
            headline: collection.title,
            previewImageURL: collection.thumbnailURL,
            contentItemValue: collection.items.first?.contentItemValue
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LibraryTableViewCell: UICollectionViewDelegateFlowLayout {

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
        return collectionViewCellType.size
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        enum ScrollDirection {
            case left
            case stationary
            case right
        }
        let cellWidth: CGFloat = collectionViewCellType.size.width
        let cellSpaceing: CGFloat = 15
        let originalTargetPage = (targetContentOffset.pointee.x) / (cellWidth + cellSpaceing)
        let scrollDirection: ScrollDirection = (velocity.x < 0) ? .left : (velocity.x > 0) ? .right : .stationary
        let targetPage: Int
        switch scrollDirection {
        case .stationary: targetPage = Int(round(originalTargetPage))
        case .left: targetPage = Int(floor(originalTargetPage))
        case .right: targetPage = Int(ceil(originalTargetPage))
        }
        targetContentOffset.pointee.x = CGFloat(targetPage) * (cellWidth + cellSpaceing)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapLibraryItem(item: contentCollection[indexPath.item])
    }
}
