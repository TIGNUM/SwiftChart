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
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.red.cgColor
        cell.backgroundColor = UIColor.clear
        return cell
    }
    init(viewModel: LearnCategoryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        var collectionView: UICollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: self.view.frame.minX, y: (self.view.frame.height - self.view.frame.width) / 2 , width: self.view.frame.width, height: self.view.frame.width), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.green
        //var contentSize:CGSize
        collectionView.collectionViewLayout = LearnCustomLayout(frame: collectionView.frame)
        layout.sectionInset = UIEdgeInsets(top: 150, left: 10, bottom: 150, right: 50)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentSize = CGSize(width: view.frame.width + 500, height: view.frame.height)
        view.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 600
    }

    }
