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

    private var viewModel: ChartViewModel?
    private lazy var currentSection = 0
    private var selectedButtonTag = 0
    private var screenType: UIViewController.ScreenType = .big
    private var pageControl: PageControl?
    weak var delegate: ChartViewControllerDelegate?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

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

    override func prepareForReuse() {
        super.prepareForReuse()

        collectionView.setContentOffset(.zero, animated: false)
        pageControl?.currentPage = 0
    }

    func setup(viewModel: ChartViewModel,
               currentSection: Int,
               screenType: UIViewController.ScreenType,
               pageControl: PageControl) {
        self.viewModel = viewModel
        self.currentSection = currentSection
        self.screenType = screenType
        self.pageControl = pageControl
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

    func chartCellSize() -> CGSize {
        let width = frame.width - ChartViewModel.chartViewPadding
        let height = width * ChartViewModel.chartRatio

        return CGSize(width: width, height: height)
    }
    
    func updatePageControl(indexPath: IndexPath) {
        pageControl?.currentPage = indexPath.item
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
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        let chartTitle = viewModel.chartTitle(section: currentSection, item: indexPath.item)
        let statistics = viewModel.statistics(section: currentSection, item: indexPath.item)
        let chartCell: ChartCell = collectionView.dequeueCell(for: indexPath)
        let chartTypes = viewModel.chartTypes(section: currentSection, item: indexPath.item)
        let config = ChartCell.Configuration.make(screenType: screenType)
        chartCell.setup(headerTitle: chartTitle,
                        chartTypes: chartTypes,
                        statistics: statistics,
                        charts: viewModel.allCharts,
                        configuration: config,
                        fitbitState: viewModel.fitbitState,
                        calandarAccessGranted: viewModel.calandarAccessGranted)
        chartCell.delegate = self
        let cellRect = collectionView.convert(chartCell.frame, to: collectionView.superview)
        chartCell.animateHeader(withCellRect: cellRect, inParentRect: collectionView.frame)

        return chartCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {        
        return chartCellSize()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left: CGFloat = 20
        let right = collectionView.bounds.width - left - chartCellSize().width

        return UIEdgeInsets(top: 0, left: left, bottom: 20, right: right)
    }
}

// MARK: - UIScrollViewDelegate

extension ChartTableViewCell: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = collectionView.visibleCells

        visibleCells.forEach { tempCell in
            guard let cell = tempCell as? ChartCell else { return }
            let cellRect = collectionView.convert(cell.frame, to: collectionView.superview)
            cell.animateHeader(withCellRect: cellRect, inParentRect: collectionView.frame)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl?.currentPage = scrollView.currentPage
    }
}

// MARK: - MyStatisticsCardCellDelegate

extension ChartTableViewCell: ChartCellDelegate {

    func doReload() {
        self.collectionView.reloadData()
    }
    
    func didSelectAddSensor() {
        delegate?.didSelectAddSensor()
    }
    
    func didSelectOpenSettings() {
        delegate?.didSelectOpenSettings()
    }
}
