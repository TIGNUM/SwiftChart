//
//  NewBaseDailyBriefCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 02/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

let standardWidth = UIScreen.main.bounds.width - 2*24.0
let detailsWidth = UIScreen.main.bounds.width

class NewBaseDailyBriefCell: UITableViewCell, Dequeueable {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTrailingConstraint: NSLayoutConstraint!
    private var datasource: [BaseDailyBriefViewModel]? = []
    private var detailsMode: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.level1.apply(self)
        selectionStyle = .none
        collectionView.registerDequeueable(NewDailyStandardBriefCollectionViewCell.self)
        collectionView.registerDequeueable(NewDailyBriefGetStartedCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
    }

    // MARK: - Public
    func configure(with models: [BaseDailyBriefViewModel]?) {
        datasource?.removeAll()

        if let modelDatasource = models {
            datasource?.append(contentsOf: modelDatasource)
        }
        if datasource?.count ?? 0 <= 1 {
            collectionView.isUserInteractionEnabled = false
        }
        var width = standardWidth - 8
        var height: CGFloat = 0

        if datasource?.first as? NewDailyBriefGetStartedModel != nil {
            width = 183
            guard let viewModel = calculateHeighest(with: datasource ?? [], forWidth: width) as? NewDailyBriefGetStartedModel else {
                return
            }
            height = NewDailyBriefGetStartedCollectionViewCell.height(for: viewModel, forWidth: width)
            collectionView.isPagingEnabled = false
            flowLayout.minimumLineSpacing = 34
        } else {
            guard let viewModel = calculateHeighest(with: datasource ?? [], forWidth: width) as? NewDailyBriefStandardModel else {
                return
            }
            detailsMode = viewModel.detailsMode ?? false
            width = detailsMode ? detailsWidth : (standardWidth - 8)
            collectionViewLeadingConstraint.constant  = detailsMode ? 0 : 24.0
            collectionViewTrailingConstraint.constant = detailsMode ? 0 : 24.0
            height = NewDailyStandardBriefCollectionViewCell.height(for: viewModel, forWidth: width)
            collectionView.isPagingEnabled = true
            flowLayout.minimumLineSpacing = detailsMode ? 0 : 8
        }

        flowLayout.itemSize = CGSize(width: width, height: height)
        collectionViewHeightConstraint.constant = height
        flowLayout.invalidateLayout()
        collectionView.reloadData()
    }
}

extension NewBaseDailyBriefCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: CollectionView delegates and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = UICollectionViewCell.init()
        if let model = datasource?[indexPath.row] as? NewDailyBriefStandardModel {
            let cell: NewDailyStandardBriefCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(with: model)
            cell.layer.borderWidth = detailsMode ? 0 :  0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            return cell
        } else if let model = datasource?[indexPath.row] as? NewDailyBriefGetStartedModel {
            let cell: NewDailyBriefGetStartedCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(with: model)
            return cell
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // expand animation
    }
}
