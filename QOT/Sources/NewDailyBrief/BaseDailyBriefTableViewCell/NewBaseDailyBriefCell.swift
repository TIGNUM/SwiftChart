//
//  NewBaseDailyBriefCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 02/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol NewBaseDailyBriefCellProtocol: class {
    func didTapOnCollectionViewCell(at indexPath: IndexPath, sender: NewBaseDailyBriefCell)
}

class NewBaseDailyBriefCell: UITableViewCell, Dequeueable {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewBottomConstraint: NSLayoutConstraint!

    var datasource: [BaseDailyBriefViewModel]? = []
    var detailsMode: Bool = false
    weak var delegate: NewBaseDailyBriefCellProtocol?
    let standardWidth = 0

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

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupCollectionView()
    }

    private func setupCollectionView() {
        var width = self.frame.width
        var height: CGFloat = 463

        if datasource?.first as? NewDailyBriefGetStartedModel != nil {
            width = 183
            guard let viewModel = calculateHeighest(with: datasource ?? [], forWidth: width) as? NewDailyBriefGetStartedModel else {
                return
            }
            height = NewDailyBriefGetStartedCollectionViewCell.height(for: viewModel, forWidth: width)
            collectionView.isPagingEnabled = false
            flowLayout.minimumLineSpacing = 34
        } else {
            if let viewModel = calculateHeighest(with: datasource ?? [], forWidth: width) as? NewDailyBriefStandardModel {
                detailsMode = viewModel.detailsMode ?? false
                width = detailsMode ? width : (width - 48)
                collectionViewTopConstraint.constant  = detailsMode ? 0 : 30.0
                collectionViewLeadingConstraint.constant  = detailsMode ? 0 : 24.0
                collectionViewTrailingConstraint.constant = detailsMode ? 0 : 24.0
                height = NewDailyStandardBriefCollectionViewCell.height(for: viewModel, forWidth: width)
                collectionView.isPagingEnabled = true
                flowLayout.minimumLineSpacing = detailsMode ? 0 : 8
            }
        }

        flowLayout.itemSize = CGSize(width: width, height: height)
        collectionViewHeightConstraint.constant = height
        flowLayout.invalidateLayout()
        collectionView.reloadData()
    }

    // MARK: - Public
    func configure(with models: [BaseDailyBriefViewModel]?) {
        datasource = models
        setupCollectionView()
    }
}

extension NewBaseDailyBriefCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: CollectionView delegates and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = datasource else {
            return 1
        }
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let model = datasource?[indexPath.row] as? NewDailyBriefStandardModel {
            let cell: NewDailyStandardBriefCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(with: model)
            if let tbvStatement = cell.body.text,
               model.domainModel?.bucketName == DailyBriefBucketName.ME_AT_MY_BEST {
                cell.body.text = "”" + tbvStatement + "”"
                cell.body.textColor = .white
            }
            cell.layer.borderWidth = detailsMode ? 0 :  0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            return cell
        } else if let model = datasource?[indexPath.row] as? NewDailyBriefGetStartedModel {
            let cell: NewDailyBriefGetStartedCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(with: model)
            return cell
        } else {
            let cell: NewDailyStandardBriefCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(with: nil)

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = datasource?[indexPath.row] as? NewDailyBriefGetStartedModel {
            model.appLink?.launch()
        }
        delegate?.didTapOnCollectionViewCell(at: indexPath, sender: self)
    }
}
