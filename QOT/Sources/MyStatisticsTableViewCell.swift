//
//  MyStatisticsTableViewCell.swift
//  QOT
//
//  Created by karmic on 07.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import RealmSwift

final class MyStatisticsTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    fileprivate var viewModel: MyStatisticsViewModel?
    fileprivate lazy var currentSection = 0

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

    // MARK: - Init

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(viewModel: MyStatisticsViewModel, currentSection: Int) {
        self.viewModel = viewModel
        self.currentSection = currentSection
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
        guard let viewModel = viewModel else {
            return 0
        }

        return viewModel.numberOfItems(in: currentSection)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            return UICollectionViewCell()
        }

        let cardTitle = viewModel.cardTitle(section: currentSection, item: indexPath.item)
        let myStatistics = viewModel.myStatistics(section: currentSection, item: indexPath.item)
        let cardType = viewModel.cardType(section: currentSection, item: indexPath.item)
        let cardCell: MyStatisticsCardCell = collectionView.dequeueCell(for: indexPath)
        cardCell.setup(headerTitle: cardTitle, cardType: cardType, delegate: self, myStatistics: myStatistics, allCards: viewModel.allCards)
        let cellRect = collectionView.convert(cardCell.frame, to: collectionView.superview)
        cardCell.animateHeader(withCellRect: cellRect, inParentRect: collectionView.frame)

        return cardCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 380)
    }
}

// MARK: - UIScrollViewDelegate

extension MyStatisticsTableViewCell: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = collectionView.visibleCells

        visibleCells.forEach { tempCell in
            guard let cell = tempCell as? MyStatisticsCardCell else { return }
            let cellRect = collectionView.convert(cell.frame, to: collectionView.superview)
            cell.animateHeader(withCellRect: cellRect, inParentRect: collectionView.frame)
        }
    }
}

// MARK: - MyStatisticsCardCellDelegate

extension MyStatisticsTableViewCell: MyStatisticsCardCellDelegate {

    func doReload() {
        self.collectionView.reloadData()
    }
}
