//
//  HorizontalHeaderView.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ReusableHeaderView: UICollectionReusableView {

    @IBOutlet private weak var containerView: HorizontalHeaderView!
    weak var delegate: TeamHeaderCellDelegate?

    func configure(headerItems: [TeamHeader]) {
        containerView.configure(headerItems: headerItems)
        containerView.delegate = delegate
    }
}

final class HorizontalHeaderView: UIView {

    @IBOutlet private weak var collectionView: UICollectionView!
    private var headerItems = [TeamHeader]()
    weak var delegate: TeamHeaderCellDelegate?

    func configure(headerItems: [TeamHeader]) {
        self.headerItems = headerItems
        collectionView.reloadData()
    }
}

extension HorizontalHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = R.reuseIdentifier.teamHeaderCell_ID.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath) as? TeamHeaderCell
        if let item = headerItems.at(index: indexPath.row) {
            cell?.configure(title: item.title,
                            hexColorString: item.hexColorString,
                            batchCount: item.batchCount,
                            selected: item.selected,
                            teamId: item.teamId)
            cell?.delegate = delegate
        }
        return cell ?? UICollectionViewCell()
    }
}
