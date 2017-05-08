//
//  LearnContentListViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import ReactiveKit
import Bond

/// The delegate of a `LearnContentListViewController`.
protocol LearnContentListViewControllerDelegate: class {
    /// Notifies `self` that the content was selected at `index` in `viewController`.
    func didSelectContent(at index: Index, in viewController: LearnContentListViewController)
    /// Notifies `self` that the back button was tapped in `viewController`.
    func didTapBack(in: LearnContentListViewController)
}

/// Displays a collection of items of learn content.
final class LearnContentListViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    let viewModel: LearnContentCollectionViewModel
    weak var delegate: LearnContentListViewControllerDelegate?
    
    init(viewModel: LearnContentCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate lazy var screenSize: CGFloat = {
        return UIScreen.main.bounds.height > 568 ? 160 : 125
    }()
    
    fileprivate lazy var collectionViewLayout: LearnContentLayout = {
        return LearnContentLayout(bubbleCount: self.viewModel.itemCount, bubbleDiameter: self.screenSize)
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.registerDequeueable(LearnContentCell.self)
        
        setupAppearance()
        setupHierachy()
        setupLayout()
        
        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .reload, .update(_, _, _):
                self.collectionViewLayout.bubbleCount = self.viewModel.itemCount
                self.collectionView.reloadData()
            }
        }.dispose(in: disposeBag)

        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        centerCollectionView()
    }
    
    private func centerCollectionView() {
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        let xOffset = (contentSize.width - collectionView.frame.width) / 2
        let yOffset = (contentSize.height - collectionView.frame.height) / 2
        collectionView.contentOffset = CGPoint(x: xOffset, y: yOffset)
    }
}

// MARK: UICollectionViewDataSource

extension LearnContentListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content = viewModel.item(at: indexPath.item)
        
        let cell: LearnContentCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: content)
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension LearnContentListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectContent(at: indexPath.item, in: self)
    }
}

private extension LearnContentListViewController {

    func setupAppearance() {
        view.backgroundColor = .clear
    }
    
    func setupHierachy() {
        view.addSubview(collectionView)
    }
    
    func setupLayout() {
        collectionView.topAnchor == view.topAnchor + 100
        collectionView.bottomAnchor == view.bottomAnchor
        collectionView.horizontalAnchors == view.horizontalAnchors
        
        view.layoutIfNeeded()
    }
}
