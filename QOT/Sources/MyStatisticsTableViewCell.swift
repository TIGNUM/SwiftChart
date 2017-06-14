//
//  MyStatisticsTableViewCell.swift
//  QOT
//
//  Created by karmic on 07.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class MyStatisticsTableViewCell: UITableViewCell, Dequeueable {

    fileprivate lazy var cards: [MyStatisticsCard] = []

    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)

        return UICollectionView(
            layout: layout,
            delegate: self,
            dataSource: self,
            dequeables: MyStatisticsCardCell.self
        )
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(cards: [MyStatisticsCard]) {
        self.cards = cards
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        self.collectionView.reloadData()
    }
}

// MARK: - Private

private extension MyStatisticsTableViewCell {

    func setupView() {
        addSubview(collectionView)
        collectionView.topAnchor == topAnchor
        collectionView.bottomAnchor == bottomAnchor
        collectionView.horizontalAnchors == horizontalAnchors
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MyStatisticsTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = cards[indexPath.item]
        let cardCell: MyStatisticsCardCell = collectionView.dequeueCell(for: indexPath)
        cardCell.setup(subTitle: card.subtitle, data: card.data, cardType: card.type, delegate: self)

        return cardCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 330)
    }
}

// MARK: - MyStatisticsCardCellDelegate

extension MyStatisticsTableViewCell: MyStatisticsCardCellDelegate {

    func doReload() {
        self.collectionView.reloadData()
    }
}
