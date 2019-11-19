//
//  DepartureBespokeFeastCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import SafariServices

final class DepartureBespokeFeastCell: BaseDailyBriefCell {
    // MARK: Properties
    @IBOutlet private weak var headerView: UIView!
    private var baseView: QOTBaseHeaderView?
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageIndicator: UIPageControl!
    @IBOutlet weak var copyrightButton: UIButton!
    @IBOutlet private weak var bespokeTitleLabel: UILabel!
    @IBOutlet private weak var departureBespokeText: UILabel!
    @IBOutlet weak var titleToSubtitleVerticalSpacingConstraint: NSLayoutConstraint!

    weak var delegate: DailyBriefViewControllerDelegate?
    private var departureBespokeFeastModel: DepartureBespokeFeastModel?
    private var visibleIndexPath = IndexPath(row: 0, section: 0)

    // MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        departureBespokeFeastModel = nil
        baseView?.titleLabel.text = nil
        bespokeTitleLabel.text = nil
        departureBespokeText.text = nil
        collectionView.reloadData()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerDequeueable(DepartureBespokeFeastImageCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        baseView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseView?.addTo(superview: headerView)
    }

    // MARK: Public
    func configure(with viewModel: DepartureBespokeFeastModel?) {
        guard let model = viewModel else { return }
        departureBespokeFeastModel = viewModel
        initialSetup()
        skeletonManager.hide()
        if let title = model.title {
            baseView?.configure(title: title.uppercased(), subtitle: nil)
        }
        if let subtitle = model.subtitle {
            ThemeText.bespokeTitle.apply(subtitle.uppercased(), to: bespokeTitleLabel)
        }
        baseView?.subtitleTextViewBottomConstraint.constant = 0
        showCopyrightButtonIfNeeded()
        ThemeText.dailyBriefSubtitle.apply(model.text, to: departureBespokeText)
        titleToSubtitleVerticalSpacingConstraint.constant = (model.text?.isEmpty ?? true) ? 0 : 14
        collectionView.reloadData()
    }

    // MARK: Private
    private func initialSetup() {
        let collectionViewWidth = UIScreen.main.bounds.width
        let height = collectionView.frame.size.height
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: collectionViewWidth, height: height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = flowLayout
    }

    private func showCopyrightButtonIfNeeded() {
        if visibleIndexPath.item < departureBespokeFeastModel?.copyrights.count ?? 0 {
            copyrightButton.isHidden = departureBespokeFeastModel?.copyrights[visibleIndexPath.item] == nil
        }
    }

    // MARK: Actions
    @IBAction func didTapCopyright(_ sender: Any) {
        guard let urlString = departureBespokeFeastModel?.copyrights[visibleIndexPath.item] else { return }
        delegate?.presentCopyRight(copyrightURL: urlString)
    }
}

extension DepartureBespokeFeastCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: CollectionView delegates and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfImages = departureBespokeFeastModel?.images.count ?? 0
        updatePageIndicator(numberOfPages: numberOfImages)
        return numberOfImages
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DepartureBespokeFeastImageCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(imageURL: URL(string: departureBespokeFeastModel?.images[indexPath.item] ?? ""))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlString = departureBespokeFeastModel?.copyrights[indexPath.item] else { return }
        delegate?.presentCopyRight(copyrightURL: urlString)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        updatePageIndicator(forCollectionView: collectionView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        updatePageIndicator(forCollectionView: collectionView)
    }

    // MARK: Helpers
    private func updatePageIndicator(forCollectionView: UICollectionView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) ?? IndexPath(item: 0, section: 0)
        pageIndicator.currentPage = visibleIndexPath.item
        showCopyrightButtonIfNeeded()
    }

    private func updatePageIndicator(numberOfPages: Int) {
        pageIndicator.isHidden = numberOfPages < 2
        pageIndicator.numberOfPages = numberOfPages
    }
}
