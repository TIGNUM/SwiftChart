//
//  ArticleCollectionViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol ArticleCollectionViewControllerDelegate: class {

    func didTapItem(articleHeader: ArticleCollectionHeader, in viewController: ArticleCollectionViewController)
}

class ArticleCollectionViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: ArticleCollectionViewModel
    weak var delegate: ArticleCollectionViewControllerDelegate?
    let theme: Theme = .dark
    
    fileprivate lazy var collectionView: UICollectionView = {
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

    init(viewModel: ArticleCollectionViewModel) {
        self.viewModel = viewModel

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
}

// MARK: - Private

private extension ArticleCollectionViewController {

    func setupLayout() {        
        view.addSubview(collectionView)
        collectionView.topAnchor == view.topAnchor
        collectionView.heightAnchor == view.heightAnchor
        collectionView.horizontalAnchors == view.horizontalAnchors
        view.layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource

extension ArticleCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let cell: ArticleCollectionCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(sortOrder:
            viewModel.sortOrder(at: index),
            title: viewModel.title(at: index),
            description: viewModel.description(at: index),
            imageURL: viewModel.previewImageURL(at: index),
            duration: "TODO"
        )

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let selectedCollection = viewModel.contentCollection(at: index)
        let articleHeader = ArticleCollectionHeader(
            articleTitle: viewModel.title(at: index),
            articleSubTitle: viewModel.description(at: index),
            articleDate: "TODO",
            articleDuration: "TODO",
            articleContentCollection: selectedCollection
        )

        delegate?.didTapItem(articleHeader: articleHeader, in: self)
        print("didSelecteItem: ", selectedCollection)
        print("selectedCollection: ", selectedCollection.articleItems.items)
    }
}

// MARK: - ArticleCollectionLayoutDelegate

extension ArticleCollectionViewController: ArticleCollectionLayoutDelegate {

    func standardHeightForLayout(_ layout: ArticleCollectionLayout) -> CGFloat {
        return 130
    }

    func featuredHeightForLayout(_ layout: ArticleCollectionLayout) -> CGFloat {
        let nonPictureHeight: CGFloat = 130
        let nonPictureWidth: CGFloat = 92
        let pictureRatio: CGFloat = 1.5
        let pictureHeight = (view.bounds.width - nonPictureWidth) / pictureRatio

        return pictureHeight + nonPictureHeight
    }
}
