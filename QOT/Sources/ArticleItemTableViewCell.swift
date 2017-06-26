//
//  ArticleItemTableViewCell.swift
//  QOT
//
//  Created by karmic on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class ArticleItemTableViewCell: UITableViewCell, Dequeueable {

    fileprivate lazy var articleItems: [ContentItem] = []
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)

        return UICollectionView(
            layout: layout,
            delegate: self,
            dataSource: self,
            dequeables: ArticleRelatedItemCell.self
        )
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(articleItems: [ContentItem]) {
        self.articleItems = articleItems
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        self.collectionView.reloadData()
    }
}

// MARK: - Private

private extension ArticleItemTableViewCell {

    func setupView() {
        addSubview(collectionView)
        collectionView.topAnchor == topAnchor
        collectionView.bottomAnchor == bottomAnchor
        collectionView.horizontalAnchors == horizontalAnchors
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ArticleItemTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleItems.count > 3 ? 3 : articleItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let article = articleItems[indexPath.item]
        let relatedArticleCell: ArticleRelatedItemCell = collectionView.dequeueCell(for: indexPath)        

        return relatedArticleCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 330)
    }
}
