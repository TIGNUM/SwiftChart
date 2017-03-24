//
//  LearnContentListViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

/// The delegate of a `LearnContentListViewController`.
protocol LearnContentListViewControllerDelegate: class {
    /// Notifies `self` that the content was selected at `index` in `viewController`.
    func didSelectContent(at index: Index, in viewController: LearnContentListViewController)
    /// Notifies `self` that the back button was tapped in `viewController`.
    func didTapBack(in: LearnContentListViewController)
}

/// Displays a collection of items of learn content.
final class LearnContentListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let viewModel: LearnContentListViewModel
    weak var delegate: LearnContentListViewControllerDelegate?
    
    init(viewModel: LearnContentListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = LearnContentLayout(frame: CGRect.zero, totalNumberOfBubbles:0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .black
        collectionView.register(LearnContentCell.self, forCellWithReuseIdentifier: "Cell")
        view.addSubview(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        collectionView.collectionViewLayout = LearnContentLayout(frame: collectionView.frame, totalNumberOfBubbles: viewModel.itemCount)
        //collectionView.transform = CGAffineTransform(rotationAngle: -0.174533)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content = viewModel.item(at: indexPath.item)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? LearnContentCell else {
            fatalError("Incorrect cell type")
        }
        cell.configure(with: content)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectContent(at: indexPath.item, in: self)
    }
}
