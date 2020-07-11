//
//  HorizontalHeaderView.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class HorizontalHeaderView: UIView {

    @IBOutlet private weak var collectionView: UICollectionView!
    private var headerItems = [Team.Item]()

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerDequeueable(TeamHeaderCell.self)
    }

    func configure(headerItems: [Team.Item]) {
        self.headerItems = headerItems
        collectionView.reloadData()
        collectionView.setContentOffset(CGPoint(x: 24, y: 0), animated: true)
    }
}

extension HorizontalHeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerItems.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = headerItems[indexPath.row].title
        let itemSize = item.size(withAttributes: [NSAttributedString.Key.font: UIFont.sfProtextSemibold(ofSize: 14)])
        return CGSize(width: itemSize.width + .TeamHeaderOffset, height: .TeamHeader)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TeamHeaderCell = collectionView.dequeueCell(for: indexPath)
        if let item = headerItems.at(index: indexPath.row) {
            switch item.header {
            case .invite:
                cell.configure(title: item.title, counter: item.batchCount)
            case .team:
                cell.configure(teamId: item.teamId, title: item.title, hexColorString: item.color, selected: item.selected)
            }
        }
        return cell
    }
}
