//
//  ChartTableViewCell.swift
//  QOT
//
//  Created by karmic on 07.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import RealmSwift

final class ChartTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    fileprivate var viewModel: ChartViewModel?
    fileprivate lazy var currentSection = 0
    fileprivate var selectedButtonTag = 0

    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)

        return UICollectionView(layout: layout,
                                delegate: self,
                                dataSource: self,
                                dequeables: ChartCell.self)
    }()

    // MARK: - Init

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(viewModel: ChartViewModel, currentSection: Int) {
        self.viewModel = viewModel
        self.currentSection = currentSection
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        self.collectionView.reloadData()
    }
}

// MARK: - Private

private extension ChartTableViewCell {

    func setupView() {
        addSubview(collectionView)
        collectionView.topAnchor == topAnchor
        collectionView.bottomAnchor == bottomAnchor
        collectionView.horizontalAnchors == horizontalAnchors
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ChartTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

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

        let chartTitle = viewModel.chartTitle(section: currentSection, item: indexPath.item)
        let statistics = viewModel.statistics(section: currentSection, item: indexPath.item)
        let chartCell: ChartCell = collectionView.dequeueCell(for: indexPath)
        let chartTypes = viewModel.chartTypes(section: currentSection, item: indexPath.item)
        chartCell.setup(headerTitle: chartTitle, chartTypes: chartTypes, statistics: statistics, charts: viewModel.allCharts)        
        chartCell.delegate = self
        let cellRect = collectionView.convert(chartCell.frame, to: collectionView.superview)
        chartCell.animateHeader(withCellRect: cellRect, inParentRect: collectionView.frame)

        return chartCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 255, height: 367)
    }
}

// MARK: - UIScrollViewDelegate

extension ChartTableViewCell: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = collectionView.visibleCells

        visibleCells.forEach { tempCell in
            guard let cell = tempCell as? ChartCell else {
                return
            }
            
            let cellRect = collectionView.convert(cell.frame, to: collectionView.superview)
            cell.animateHeader(withCellRect: cellRect, inParentRect: collectionView.frame)
        }
    }
}

// MARK: - MyStatisticsCardCellDelegate

extension ChartTableViewCell: ChartCellDelegate {

    func doReload() {
        self.collectionView.reloadData()
    }
}
