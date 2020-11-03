//
//  NewBaseDailyBriefCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 02/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

let width = UIScreen.main.bounds.width - 2*24.0

class NewBaseDailyBriefCell: UITableViewCell, Dequeueable {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    private var datasource: [NewBaseDailyBriefModel]? = []

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.level1.apply(self)
        selectionStyle = .none
        collectionView.registerDequeueable(NewDailyBriefCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
    }

    // MARK: - Public
    func configure(with models: [NewBaseDailyBriefModel]?) {
        datasource?.removeAll()
        if let modelDatasource = models {
            datasource?.append(contentsOf: modelDatasource)
        }
        guard let viewModel = calculateHeighest(with: datasource ?? [], forWidth: width) else {
            return
        }
        let height = NewDailyBriefCollectionViewCell.height(for: viewModel, forWidth: width)

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
        let cell: NewDailyBriefCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: datasource?[indexPath.row])
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // expand animation
//        guard let urlString = departureBespokeFeastModel?.copyrights.at(index: indexPath.item) else { return }
//        let copyrightDescription = AppTextService.get(.daily_brief_alert_copyright_title)
//        delegate?.presentPopUp(copyrightURL: urlString, description: copyrightDescription)
    }
}
