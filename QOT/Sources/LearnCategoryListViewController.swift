//
//  LearnCategoriesViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import Foundation
import Bond
import ReactiveKit

/// The delegate of a `LearnCategoryListViewController`.
protocol LearnCategoryListViewControllerDelegate: class {
    /// Notifies `self` that the category was selected at `index` in `viewController`.
    func didSelectCategory(at index: Index, withFrame frame: CGRect, in viewController: LearnCategoryListViewController)
}

/// Displays a collection of learn categories of learn content.
final class LearnCategoryListViewController: UIViewController, PageViewControllerNotSwipeable {

    // MARK: - Properties

    private let viewModel: LearnCategoryListViewModel
    private let disposeBag = DisposeBag()
    private let learnCategoryLayout = LearnCategoryLayout()
    weak var delegate: LearnCategoryListViewControllerDelegate?
    let page = LearnCategoryListPage()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(layout: learnCategoryLayout,
                                              delegate: self,
                                              dataSource: self,
                                              dequeables: LearnCategoryCell.self,
                                              LearnContentCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return collectionView
    }()

    // MARK: - Init

    init(viewModel: LearnCategoryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .reload:
                self.collectionView.reloadData()
            case .update(let deletions, let insertions, let modifications):
                self.collectionView.performBatchUpdates({
                    self.collectionView.deleteItems(at: deletions)
                    self.collectionView.insertItems(at: insertions)
                })
                self.reloadCells(indexPaths: modifications)
            }
        }.dispose(in: disposeBag)
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent)
        learnCategoryLayout.centerCollectionView()
        collectionView.reloadData()
    }
}

// MARK: - Private

private extension LearnCategoryListViewController {

    func reloadCells(indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            let category = viewModel.item(at: indexPath.item)
            if let cell = collectionView.cellForItem(at: indexPath) as? LearnCategoryCell {
                cell.configure(with: category, indexPath: indexPath)
            }
        }
    }

    func centerCollectionView() {
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        let xOffset = (contentSize.width - collectionView.frame.width) / 2
        collectionView.contentOffset = CGPoint(x: xOffset, y: collectionView.contentOffset.y)
    }

    func setupLayout() {
        view.addSubview(collectionView)
        if #available(iOS 11.0, *) {
            collectionView.topAnchor == view.safeTopAnchor
            collectionView.bottomAnchor == view.safeBottomAnchor
            collectionView.leadingAnchor == view.leadingAnchor
            collectionView.trailingAnchor == view.trailingAnchor
        } else {
            collectionView.topAnchor == view.topAnchor + Layout.statusBarHeight
            collectionView.bottomAnchor == view.bottomAnchor - Layout.statusBarHeight
            collectionView.leadingAnchor == view.leadingAnchor
            collectionView.trailingAnchor == view.trailingAnchor
        }
        view.backgroundColor = .navy
        view.layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension LearnCategoryListViewController: UICollectionViewDataSource, LearnCategoryLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = viewModel.item(at: indexPath.item)
        let cell: LearnCategoryCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: category, indexPath: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let cellFrame = collectionView.convert(attributes.frame, to: view)
        delegate?.didSelectCategory(at: indexPath.row, withFrame: cellFrame, in: self)
        generateFeedback()
    }

    func bubbleLayoutInfo(layout: LearnCategoryLayout, index: Index) -> BubbleLayoutInfo {
        return page.bubbleLayoutInfo(at: index)
    }
}
