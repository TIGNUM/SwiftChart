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
    func didSelectCategory(at index: Index, in viewController: LearnCategoryListViewController)
}

//  FIXME: This is a dummy implementation of LearnCategoryListViewController.

/// Displays a collection of learn categories of learn content.
final class LearnCategoryListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var viewModel: LearnCategoryListViewModel
    weak var delegate: LearnCategoryListViewControllerDelegate?
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = viewModel.category(at: indexPath.item)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? LearnCategoryCell else {
            fatalError("Incorrect cell type")
        }
        cell.configure(with: category)
        
        return cell
    }
    init(viewModel: LearnCategoryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        var collectionView: UICollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY + 70, width: self.view.frame.width, height: self.view.frame.height - 120), collectionViewLayout: layout)
        let image: UIImage = UIImage(named:"LearnCategory.png")!
        let imageView = UIImageView(frame:collectionView.frame)
        imageView.contentMode = .scaleToFill
        imageView.image = image
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LearnCategoryCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.black
        collectionView.collectionViewLayout = LearnCategoryLayout(frame: collectionView.frame)
        layout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentSize = CGSize(width: view.frame.width + 500, height: view.frame.height)
        view.addSubview(collectionView)
        collectionView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryCount
    }
}
