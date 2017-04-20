//
//  LearnCategoriesViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

/// The delegate of a `LearnCategoryListViewController`.
protocol LearnCategoryListViewControllerDelegate: class {
    /// Notifies `self` that the category was selected at `index` in `viewController`.
    func didSelectCategory(_ category: LearnCategory, in viewController: LearnCategoryListViewController)
}

/// Displays a collection of learn categories of learn content.
final class LearnCategoryListViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Properties
    
    let viewModel: LearnCategoryListViewModel
    weak var delegate: LearnCategoryListViewControllerDelegate?

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

        let layout = LearnCategoryLayout(height: collectionView.frame.height, categories: viewModel.categories)
        collectionView.collectionViewLayout = layout
        collectionView.registerDequeueable(LearnCategoryCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        centerCollectView()
        view.backgroundColor = .yellow
    }
    
    private func centerCollectView() {
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        let xOffset = (contentSize.width - collectionView.frame.width) / 2
        let yOffset = (contentSize.height - collectionView.frame.height) / 2
        collectionView.contentOffset = CGPoint(x: xOffset, y: yOffset)

        print(collectionView.contentSize, collectionView.contentOffset)
    }
}

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
        delegate?.didSelectCategory(viewModel.category(at: indexPath.row), in: self)
    }
}
