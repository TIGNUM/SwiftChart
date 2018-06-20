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

protocol LearnContentListViewControllerDelegate: class {

    func didSelectContent(_ content: ContentCollection,
                          category: ContentCategory,
                          originFrame: CGRect, in viewController: LearnContentListViewController)
}

/// Displays a collection of items of learn content.
final class LearnContentListViewController: UIViewController {

    // MARK: - Properties

    weak var pagingCollectionViewTopConstraint: NSLayoutConstraint?
    weak var pagingCollectionViewBottomConstraint: NSLayoutConstraint?
    private let backgroundImageView = UIImageView(image: R.image._1Learn())
    private let disposeBag = DisposeBag()
    private lazy var collectionViewLayout = LearnStrategyListLayout()
    let viewModel: LearnContentCollectionViewModel
    var selectedCategoryIndex: Index
    weak var delegate: LearnContentListViewControllerDelegate?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(layout: self.collectionViewLayout,
                                              delegate: self,
                                              dataSource: self,
                                              dequeables: LearnContentCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 55, right: 0)
        return collectionView
    }()

    // MARK: - Init

    init(viewModel: LearnContentCollectionViewModel, selectedCategoryIndex: Index) {
        self.viewModel = viewModel
        self.selectedCategoryIndex = selectedCategoryIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupHierachy()
        setupLayout()
        observeViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}

// MARK: - Private

private extension LearnContentListViewController {

    func observeViewModel() {
        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .reload, .update:
                self.collectionView.reloadData()
            }
        }.dispose(in: disposeBag)
    }

    func setupAppearance() {
        view.backgroundColor = .clear
        collectionView.backgroundColor = .clear
    }

    func setupHierachy() {
        view.addSubview(backgroundImageView)
        view.addSubview(collectionView)
    }

    func setupLayout() {
        backgroundImageView.edgeAnchors == view.edgeAnchors
        collectionView.topAnchor == view.topAnchor
        collectionView.bottomAnchor == view.safeBottomAnchor
        collectionView.horizontalAnchors == view.horizontalAnchors
        view.layoutIfNeeded()
    }
}

// MARK: UICollectionViewDataSource

extension LearnContentListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount(categoryIndex: selectedCategoryIndex)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.item(at: indexPath, categorySelectedIndex: selectedCategoryIndex)
        let cell: LearnContentCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: item, index: indexPath.item)

        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension LearnContentListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = viewModel.item(at: indexPath, categorySelectedIndex: selectedCategoryIndex)
        let category = viewModel.category(at: indexPath.section)
        guard var originFrame = collectionView.cellForItem(at: indexPath)?.frame else { return }
        originFrame = collectionView.convert(originFrame, to: view)
        delegate?.didSelectContent(content, category: category, originFrame: originFrame, in: self)
        generateFeedback()
    }
}
