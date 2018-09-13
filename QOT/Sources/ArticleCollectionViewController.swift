//
//  ArticleCollectionViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import ReactiveKit
import Bond

protocol ArticleCollectionViewControllerDelegate: class {

    func didTapItem(articleHeader: ArticleCollectionHeader, in viewController: UIViewController)
    func viewWillAppear(in viewController: ArticleCollectionViewController)
    func viewDidDisappear(in viewController: ArticleCollectionViewController)
}

final class ArticleCollectionViewController: UIViewController, FullScreenLoadable, PageViewControllerNotSwipeable {

    // MARK: - Properties

    private let backgroundImageView: UIImageView
    private let fadeMaskLocation: UIView.FadeMaskLocation

    private(set) var isShowing = false
    weak var delegate: ArticleCollectionViewControllerDelegate?
    let pageName: PageName
    var loadingView: BlurLoadingView?
    var isLoading: Bool = false {
        didSet {
            showLoading(isLoading, text: R.string.localized.articleLoading())
        }
    }
    var viewData: ArticleCollectionViewData {
        didSet {
            reload()
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layout = ArticleCollectionLayout()
        layout.delegate = self

        return UICollectionView(
            layout: layout,
            delegate: self,
            dataSource: self,
            dequeables: ArticleCollectionCell.self
        )
    }()

    // MARK: Init

    init(pageName: PageName, viewData: ArticleCollectionViewData, fadeMaskLocation: UIView.FadeMaskLocation) {
        self.pageName = pageName
        self.viewData = viewData
        self.fadeMaskLocation = fadeMaskLocation
        backgroundImageView = UIImageView(image: R.image.backgroundStrategies())

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isShowing = true
        delegate?.viewWillAppear(in: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateReadyState()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isShowing = false
        delegate?.viewDidDisappear(in: self)
    }

    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        collectionView.contentInset.top = Layout.padding_24 + view.safeMargins.top
        collectionView.contentInset.bottom = view.safeMargins.bottom
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        view.setFadeMask(at: fadeMaskLocation)
    }
}

// MARK: - Private

private extension ArticleCollectionViewController {

    func updateReadyState() {
        isLoading = !viewData.isReady
    }

    func reload() {
        collectionView.reloadData()
        updateReadyState()
    }

    func setupLayout() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(backgroundImageView)
        backgroundImageView.edgeAnchors == view.edgeAnchors
        view.addSubview(collectionView)

        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.edgeAnchors == view.edgeAnchors
            collectionView.contentInset.top = Layout.padding_24 + view.safeMargins.top
            collectionView.contentInset.bottom = view.safeMargins.bottom
        } else {
            collectionView.topAnchor == view.topAnchor + Layout.statusBarHeight + Layout.padding_24
            collectionView.bottomAnchor == view.bottomAnchor
            collectionView.leadingAnchor == view.leadingAnchor
            collectionView.trailingAnchor == view.trailingAnchor
            collectionView.contentInset.top = Layout.padding_24
        }

        view.setFadeMask(at: fadeMaskLocation)
    }
}

// MARK: - UICollectionViewDataSource

extension ArticleCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewData.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ArticleCollectionCell = collectionView.dequeueCell(for: indexPath)
        let item = viewData.items[indexPath.row]

        cell.configure(articleDate: item.articleDate,
                       sortOrder: item.sortOrder,
                       title: item.title,
                       description: item.description,
                       imageURL: item.previewImageURL,
                       duration: item.duration,
                       showSeparator: indexPath.row + 1 != viewData.items.count
        )

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewData.items[indexPath.row]
		let articleHeader = ArticleCollectionHeader(articleTitle: item.title,
													articleSubTitle: item.description,
													articleDate: item.articleDate,
													articleDuration: item.duration,
													articleContentCollectionID: item.contentCollectionID,
													thumbnail: item.previewImageURL)
        delegate?.didTapItem(articleHeader: articleHeader, in: self)
    }
}

// MARK: - ArticleCollectionLayoutDelegate

extension ArticleCollectionViewController: ArticleCollectionLayoutDelegate {

    func standardHeightForLayout(_ layout: ArticleCollectionLayout) -> CGFloat {
        return 130
    }

    func featuredHeightForLayout(_ layout: ArticleCollectionLayout) -> CGFloat {
        let nonPictureHeight: CGFloat = 130
        let nonPictureWidth: CGFloat = 93
        let pictureRatio: CGFloat = 1.5
        let pictureHeight = (view.bounds.width - nonPictureWidth) / pictureRatio

        return pictureHeight + nonPictureHeight
    }
}
