//
//  MyDataCharTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataChartTableViewCell: MyDataBaseTableViewCollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var graphContentView: UIView!
    @IBOutlet weak var graphCollectionView: UICollectionView!
    @IBOutlet weak var collectionContentViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionContentViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!

    let screenWidth = UIScreen.main.bounds.width
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGraphCollectionView()
        skeletonManager.addOtherView(graphContentView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.graphCollectionView.reloadData()
    }

    // MARK: - Public
    func reloadCalendarData() {
        self.graphCollectionView.reloadData()
    }

    func setGraphCollectionViewDelegate(_ delegate: UICollectionViewDelegate) {
        self.graphCollectionView.delegate = delegate
    }

    func setGraphCollectionViewDatasource(_ datasource: UICollectionViewDataSource) {
        self.graphCollectionView.dataSource = datasource
    }

    // MARK: - Private
    private func setupGraphCollectionView() {
        //general setup of GraphCollectionView
        let collectionViewWidth = screenWidth - (collectionContentViewLeadingConstraint.constant + collectionContentViewTrailingConstraint.constant)
        let height = self.graphCollectionView.frame.size.height
        self.graphCollectionView.registerDequeueable(MyDataChartCollectionViewCell.self)
        self.graphCollectionView.isPagingEnabled = true
        self.graphCollectionView.showsHorizontalScrollIndicator = false
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: collectionViewWidth, height: height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        self.graphCollectionView.collectionViewLayout = flowLayout
        self.stackViewTrailingConstraint.constant = (collectionViewWidth/6) + stackViewLeadingConstraint.constant
        self.populateWeekdaysLabels(Date().firstDayOfWeek())
        self.setMonthAndYear(text: DateFormatter.MMMyyyy.string(from: Date().lastDayOfWeek().dateAfterDays(-3)))
        showTodaysWeekdayLabel(asHighlighted: true)
    }
}
