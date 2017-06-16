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
    func didSelectCategory(at index: Index, category: LearnContentCategory, in viewController: LearnCategoryListViewController)

}

protocol LearnCategoryUpdateDelegate: class {
    func didUpdateCategoryViewedPercentage()
}

/// Displays a collection of learn categories of learn content.
final class LearnCategoryListViewController: UIViewController {

    // MARK: - Properties
    
    fileprivate let viewModel: LearnCategoryListViewModel
    fileprivate let disposeBag = DisposeBag()
    weak var delegate: LearnCategoryListViewControllerDelegate?

    fileprivate lazy var collectionView: UICollectionView = {
        let layout = LearnCategoryLayout(
            height: self.view.frame.height - Layout.TabBarView.height,
            categories: self.viewModel.categories
        )

        return UICollectionView(
            layout: layout,
            delegate: self,
            dataSource: self,
            dequeables:
                LearnCategoryCell.self,
                LearnContentCell.self
        )
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

        setupLayout()
        viewModel.updates.observeNext { [unowned self] (_) in
            self.collectionView.reloadData()
        }.dispose(in: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.centerCollectionView()
    }
}

// MARK: - Private

private extension LearnCategoryListViewController {

    func centerCollectionView() {
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        let xOffset = (contentSize.width - collectionView.frame.width) / 2
        collectionView.contentOffset = CGPoint(x: xOffset, y: collectionView.contentOffset.y)
    }

    func setupLayout() {
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.topAnchor == view.topAnchor + Layout.TabBarView.height
        collectionView.bottomAnchor == view.bottomAnchor
        collectionView.horizontalAnchors == view.horizontalAnchors
        view.layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension LearnCategoryListViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = viewModel.category(at: indexPath.item)
        let cell: LearnCategoryCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: category)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCategory(at: indexPath.row, category: viewModel.category(at: indexPath.row), in: self)
    }
}

// MARK: - LearnCategoryUpdateDelegate

extension LearnCategoryListViewController: LearnCategoryUpdateDelegate {

    func didUpdateCategoryViewedPercentage() {
        collectionView.reloadData()
    }
}
