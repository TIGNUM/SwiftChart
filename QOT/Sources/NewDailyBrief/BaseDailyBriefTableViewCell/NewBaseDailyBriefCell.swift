//
//  NewBaseDailyBriefCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 02/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum SkeletonMode {
    case getStarted
    case standard
}

protocol NewBaseDailyBriefCellProtocol: class {
    func didTapOnCollectionViewCell(at indexPath: IndexPath, sender: NewBaseDailyBriefCell)
}

class NewBaseDailyBriefCell: UITableViewCell, Dequeueable {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var flowLayout: MyCollectionViewFlowLayout!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewBottomConstraint: NSLayoutConstraint!

    var datasource: [BaseDailyBriefViewModel]? = []
    var detailsMode: Bool = false
    weak var delegate: NewBaseDailyBriefCellProtocol?
    let standardWidth = 0
    var skeletonMode: SkeletonMode = .standard

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
        var width = self.frame.width - (detailsMode ? 0 : 48)
        var height: CGFloat = 463
        collectionView.bounces = datasource?.count ?? 0 > 1
        collectionView.decelerationRate = .fast

        if (datasource?.first as? NewDailyBriefGetStartedModel != nil && datasource?.count ?? 0 > 0) || skeletonMode == .getStarted {
            width = 183
            let viewModel: NewDailyBriefGetStartedModel? = calculateHeighest(with: datasource ?? [], forWidth: width) as? NewDailyBriefGetStartedModel
            let dummyModel = NewDailyBriefGetStartedModel.init(title: "Label",
                                                               image: nil,
                                                               appLink: nil,
                                                               domainModel: nil)
            height = NewDailyBriefGetStartedCollectionViewCell.height(for: viewModel ?? dummyModel, forWidth: width)
            collectionView.isPagingEnabled = false
            flowLayout.minimumLineSpacing = 34
        } else {
            let viewModel: NewDailyBriefStandardModel? = calculateHeighest(with: datasource ?? [], forWidth: width) as? NewDailyBriefStandardModel
            let dummyModel = NewDailyBriefStandardModel.init(caption: "Caption",
                                                             title: "Label",
                                                             body: "Label label label label",
                                                             image: nil,
                                                             domainModel: nil)
            detailsMode = viewModel?.detailsMode ?? false
            collectionViewTopConstraint.constant  = detailsMode ? 0 : 30.0
            height = NewDailyStandardBriefCollectionViewCell.height(for: viewModel ?? dummyModel, forWidth: width)
            collectionView.isPagingEnabled = false
            flowLayout.minimumLineSpacing = detailsMode ? 0 : 8.0
        }
        flowLayout.sectionInset.left = detailsMode ? 0 : 24.0
        flowLayout.sectionInset.right = detailsMode ? 0 : 24.0

        flowLayout.itemSize = CGSize(width: width, height: height)
        collectionViewHeightConstraint.constant = height
        flowLayout.invalidateLayout()
        collectionView.reloadData()
    }

    // MARK: - Public
    func configure(with models: [BaseDailyBriefViewModel]?, skeletonMode: SkeletonMode = .standard) {
        datasource = models
        self.skeletonMode = skeletonMode
        setupCollectionView()
    }
}

extension NewBaseDailyBriefCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: CollectionView delegates and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = datasource else {
            switch skeletonMode {
            case .standard:
                return 1
            case .getStarted:
                return 3
            }
        }
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let model = datasource?[indexPath.row] as? NewDailyBriefStandardModel {
            let cell: NewDailyStandardBriefCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(with: model)
            if let tbvStatement = cell.body.text,
               model.domainModel?.bucketName == DailyBriefBucketName.ME_AT_MY_BEST {
                cell.body.text = tbvStatement
                cell.body.textColor = .white
            }
            cell.layer.borderWidth = detailsMode ? 0 :  0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.contentView.alpha = model.enabled ? 1.0 : 0.2
            cell.isUserInteractionEnabled = model.enabled
            return cell
        } else if let model = datasource?[indexPath.row] as? NewDailyBriefGetStartedModel {
            let cell: NewDailyBriefGetStartedCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(with: model)
            return cell
        } else {
            switch skeletonMode {
            case .standard:
                let cell: NewDailyStandardBriefCollectionViewCell = collectionView.dequeueCell(for: indexPath)
                cell.configure(with: nil)

                return cell
            case .getStarted:
                let cell: NewDailyBriefGetStartedCollectionViewCell = collectionView.dequeueCell(for: indexPath)
                cell.configure(with: nil)

                return cell
            }

        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = datasource?[indexPath.row] as? NewDailyBriefGetStartedModel {
            model.appLink?.launch()
        }
        delegate?.didTapOnCollectionViewCell(at: indexPath, sender: self)
    }
}

class MyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
                let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
                return latestOffset
            }

        // Page width used for estimating and calculating paging.
        let pageWidth = self.itemSize.width + self.minimumInteritemSpacing

        // Make an estimation of the current page position.
        let approximatePage = collectionView.contentOffset.x/pageWidth

        // Determine the current page based on velocity.
        let currentPage = velocity.x == 0 ? round(approximatePage) : (velocity.x < 0.0 ? floor(approximatePage) : ceil(approximatePage))

        // Create custom flickVelocity.
        let flickVelocity = velocity.x * 0.3

        // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)

        // Calculate newHorizontalOffset.
        let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - collectionView.contentInset.left

        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
    }
}
