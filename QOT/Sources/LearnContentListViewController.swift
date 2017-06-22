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
    fileprivate var isDragging = false

    fileprivate lazy var pagingCellSize: CGSize = {
        return CGSize(width: self.view.frame.width / 2, height: 40)
    }()

    fileprivate lazy var performanceLabelSize: CGSize = {
        return CGSize(width: self.view.frame.width, height: 40)
    }()

    fileprivate lazy var screenSize: CGFloat = {
        return UIScreen.main.bounds.height > 568 ? 160 : 125
    }()

    fileprivate lazy var collectionViewLayout: LearnStrategyListLayout = {
        return LearnStrategyListLayout()
    }()

    fileprivate lazy var collectionView: UICollectionView = {
        return UICollectionView(
            layout: self.collectionViewLayout,
            delegate: self,
            dataSource: self,
            dequeables: LearnContentCell.self
        )
    }()

    fileprivate lazy var headerLabel: UILabel = {
        let label = UILabel()

        label.text = R.string.localized.learnContentPerformanceTitle()
        label.textColor = .white
        label.font = Font.H6NavigationTitle
        label.textAlignment = .center
        label.backgroundColor = .clear

        return label
    }()

    fileprivate lazy var pagingCollectionView: UICollectionView = {        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        return UICollectionView(
            layout: layout,
            contentInsets: UIEdgeInsets(top: 0, left: self.pagingCellSize.width / 2, bottom: 0, right: self.pagingCellSize.width / 2),
            delegate: self,
            dataSource: self,
            dequeables: LearnPagingCollectionViewCell.self)
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
        
//        centerCollectionView()
        pagingCollectionViewScrollToSelectedIndex()
    }
}

// MARK: - Private

private extension LearnContentListViewController {

    func observeViewModel() {
        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .reload, .update:
                self.collectionView.reloadData()
                self.pagingCollectionViewScrollToSelectedIndex(false)
            }
        }.dispose(in: disposeBag)
    }

    func pagingCollectionViewScrollToSelectedIndex(_ reloadAll: Bool = true) {
        guard selectedCategoryIndex < pagingCollectionView.numberOfItems(inSection: 0) else { return }
        guard let flowLayout = pagingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let originX = (pagingCellSize.width + flowLayout.minimumInteritemSpacing) * CGFloat(selectedCategoryIndex)

        let origin = CGPoint(x: originX, y: 0)
        let rect = CGRect(x: origin.x, y: origin.y, width: pagingCellSize.width, height: pagingCellSize.height)
        pagingCollectionView.scrollRectToVisible(rect, animated: true)

        pagingCollectionView.reloadData()

        viewModel.updateContentCollection(at: selectedCategoryIndex)

        if reloadAll {
            collecitonViewScrollToCategory(false)
        }
    }

    func collecitonViewScrollToCategory(_ reloadAll: Bool = true) {
        guard selectedCategoryIndex < numberOfSections(in: collectionView) else { return }
        guard let layout = collectionView.collectionViewLayout as? LearnStrategyListLayout else { return }

        if selectedCategoryIndex < layout.sectionOrigins.count {
            let origin = layout.sectionOrigins.item(at: selectedCategoryIndex)
            let rect = CGRect(x: origin.x, y: origin.y, width: collectionView.frame.width, height: collectionView.frame.height)
            collectionView.scrollRectToVisible(rect, animated: true)

            collectionView.reloadData()
        }

        if reloadAll {
            pagingCollectionViewScrollToSelectedIndex(false)
        }
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
        view.insertSubview(headerLabel, at: 0)
        view.insertSubview(pagingCollectionView, at: 1)
        view.addSubview(collectionView)
        view.addSubview(getBackButton)
    }

    @objc func didTapGetBack() {
        delegate?.didTapBack(in: self)
    }

    func setupLayout() {
        collectionView.topAnchor == view.topAnchor + pagingCellSize.height + performanceLabelSize.height
        collectionView.bottomAnchor == view.bottomAnchor - 64
        collectionView.horizontalAnchors == view.horizontalAnchors

        pagingCollectionView.topAnchor == headerLabel.bottomAnchor
        pagingCollectionView.bottomAnchor == headerLabel.bottomAnchor + pagingCellSize.height
        pagingCollectionView.horizontalAnchors == view.horizontalAnchors

        headerLabel.topAnchor == view.topAnchor + 20
        headerLabel.bottomAnchor == view.topAnchor + performanceLabelSize.height
        headerLabel.horizontalAnchors == view.horizontalAnchors

        view.layoutIfNeeded()
    }
}

// MARK: UICollectionViewDataSource

extension LearnContentListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return collectionView === self.collectionView ? viewModel.categoryCount : 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.collectionView {
            return viewModel.category(at: section).itemCount
        } else {
            return viewModel.categoryCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.collectionView {
            let cell: LearnContentCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(with: viewModel.category(at: indexPath.section).learnContent.item(at: indexPath.item), index: indexPath.item)

            return cell
        }

        let category = viewModel.category(at: indexPath.item)
        let cell: LearnPagingCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(title: category.title, shouldHighlight: selectedCategoryIndex == indexPath.item)

        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension LearnContentListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === self.collectionView {
//            delegate?.didSelectContent(at: indexPath.item, in: self)
        } else {
            selectedCategoryIndex = indexPath.item
            pagingCollectionViewScrollToSelectedIndex()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === self.pagingCollectionView {
            return pagingCellSize
        }

        return .zero
    }
}

// MARK: UIScrollViewDelegate

extension LearnContentListViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let collectionView = (scrollView as? UICollectionView) else { return }
        guard collectionView === self.collectionView else { return }

        isDragging = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = (scrollView as? UICollectionView) else { return }
        guard collectionView === self.collectionView else { return }
        guard isDragging == true else { return }

        let center = CGPoint(x: collectionView.frame.midX, y: collectionView.frame.midY)
        let convertedCenter = view.convert(center, to: collectionView)

        guard let indexPath = collectionView.indexPathForItem(at: convertedCenter) else { return }

        if selectedCategoryIndex != indexPath.section {
            selectedCategoryIndex = indexPath.section
            pagingCollectionViewScrollToSelectedIndex(false)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidScroll(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isDragging = false

        guard let collectionView = (scrollView as? UICollectionView) else { return }
        guard collectionView === pagingCollectionView else { return }
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let spacing = flowLayout.minimumInteritemSpacing
        let pageWidth: Float = Float(pagingCellSize.width + spacing)
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0

        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        } else {
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }

        var index = selectedCategoryIndex
        if newTargetOffset < 0 {
            newTargetOffset = 0
            index = 0
        } else if newTargetOffset > Float(collectionView.contentSize.width) {
            newTargetOffset = Float(Float(collectionView.contentSize.width))
            let items = collectionView.numberOfItems(inSection: 0)
            index = items > 0 ? items - 1 : index
        } else {
            index = Int(newTargetOffset / pageWidth) + 1
        }

        selectedCategoryIndex = index

        if index == 0 {
            pagingCollectionViewScrollToSelectedIndex()
        } else {
            targetContentOffset.pointee.x = CGFloat(currentOffset)
            scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)
            collectionView.reloadData()
            collecitonViewScrollToCategory(false)
        }
    }
}
