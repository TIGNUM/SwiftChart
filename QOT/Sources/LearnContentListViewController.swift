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
    func didTapBack(in viewController: LearnContentListViewController)
}

/// Displays a collection of items of learn content.
final class LearnContentListViewController: UIViewController {

    // MARK: - Properties

    fileprivate let disposeBag = DisposeBag()
    fileprivate let viewModel: LearnContentCollectionViewModel
    fileprivate var selectedCategoryIndex: Index
    weak var delegate: LearnContentListViewControllerDelegate?

    fileprivate lazy var pagingCellSize: CGSize = {
        return CGSize(width: self.view.frame.width / 3, height: 100)
    }()

    fileprivate lazy var screenSize: CGFloat = {
        return UIScreen.main.bounds.height > 568 ? 160 : 125
    }()

    fileprivate lazy var collectionViewLayout: LearnContentLayout = {
        return LearnContentLayout(bubbleCount: self.viewModel.itemCount, bubbleDiameter: self.screenSize)
    }()

    fileprivate lazy var collectionView: UICollectionView = {
        return UICollectionView(
            layout: self.collectionViewLayout,
            delegate: self,
            dataSource: self,
            dequeables: LearnContentCell.self
        )
    }()

    fileprivate lazy var pagingCollectionView: UICollectionView = {        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        return UICollectionView(
            layout: layout,
            contentInsets: UIEdgeInsets(top: 0, left: self.pagingCellSize.width, bottom: 0, right: self.pagingCellSize.width),
            delegate: self,
            dataSource: self,
            dequeables: LearnPagingCollectionViewCell.self
        )
    }()

    fileprivate lazy var getBackButton: UIButton = {
        let viewFrame = self.view.bounds
        let button = UIButton(frame: CGRect(x: 0, y: viewFrame.height - Layout.TabBarView.height, width: viewFrame.width, height: Layout.TabBarView.height))
        button.setTitle("TAP TO GET BACK", for: .normal)
        button.setTitleColor(Color.whiteMedium, for: .normal)
        button.titleLabel?.font = Font.H4Headline
        button.addTarget(self, action: #selector(didTapGetBack), for: .touchUpInside)

        return button
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
        
        centerCollectionView()
        pagingCollectionViewScrollToSelectedIndex()
    }
}

// MARK: - Private

private extension LearnContentListViewController {

    func observeViewModel() {
        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .reload, .update(_, _, _):
                self.collectionViewLayout.bubbleCount = self.viewModel.itemCount
                UIView.animate(withDuration: 0.9) {
                    self.collectionView.reloadData()
                    self.pagingCollectionView.reloadData()
                }

                self.pagingCollectionViewScrollToSelectedIndex()
            }
        }.dispose(in: disposeBag)
    }

    func pagingCollectionViewScrollToSelectedIndex() {
        let indexPath = IndexPath(item: selectedCategoryIndex, section: 0)
        pagingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func centerCollectionView() {
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        let xOffset = (contentSize.width - collectionView.frame.width) / 2
        let yOffset = (contentSize.height - collectionView.frame.height) / 2
        collectionView.contentOffset = CGPoint(x: xOffset, y: yOffset)
    }

    func setupAppearance() {
        view.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        pagingCollectionView.backgroundColor = .clear
    }

    func setupHierachy() {
        view.insertSubview(pagingCollectionView, at: 0)
        view.addSubview(collectionView)
        view.addSubview(getBackButton)
    }

    @objc func didTapGetBack() {
        delegate?.didTapBack(in: self)
    }

    func setupLayout() {
        collectionView.topAnchor == view.topAnchor + pagingCellSize.height
        collectionView.bottomAnchor == view.bottomAnchor
        collectionView.horizontalAnchors == view.horizontalAnchors

        pagingCollectionView.topAnchor == view.topAnchor
        pagingCollectionView.bottomAnchor == view.topAnchor + pagingCellSize.height
        pagingCollectionView.horizontalAnchors == view.horizontalAnchors

        view.layoutIfNeeded()
    }
}

// MARK: UICollectionViewDataSource

extension LearnContentListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.collectionView {
            return viewModel.itemCount
        } else {
            return viewModel.categoryCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.collectionView {
            let content = viewModel.item(at: indexPath.item)
            let cell: LearnContentCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(with: content, index: indexPath.item)

            return cell
        }

        let category = viewModel.category(at: indexPath.item)
        let cell: LearnPagingCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(title: category.title, shouldHighlight: selectedCategoryIndex == indexPath.item)

        return cell
    }
}

// MARK: UICollectionViewDelegate

extension LearnContentListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === self.collectionView {
            delegate?.didSelectContent(at: indexPath.item, in: self)
        } else {
            selectedCategoryIndex = indexPath.item
            viewModel.updateContentCollection(at: indexPath.item)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === self.pagingCollectionView {
            return pagingCellSize
        }

        return .zero
    }
}
