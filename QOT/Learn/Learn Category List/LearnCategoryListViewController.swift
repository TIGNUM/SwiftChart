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
    
    let viewModel: LearnCategoryListViewModel
    weak var delegate: LearnCategoryListViewControllerDelegate?

    lazy var collectionView: UICollectionView = {
        let layout = LearnCategoryLayout(height: self.view.frame.height - 64, categories: self.viewModel.categories)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.registerDequeueable(LearnCategoryCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerDequeueable(LearnContentCell.self)
        collectionView.backgroundColor = .clear

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

        setupHierachy()
        setupLayout()
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
        collectionView.topAnchor == view.topAnchor + 64
        collectionView.bottomAnchor == view.bottomAnchor
        collectionView.horizontalAnchors == view.horizontalAnchors

        view.backgroundColor = .clear
        view.layoutIfNeeded()
    }

    func setupHierachy() {
        view.addSubview(collectionView)
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
