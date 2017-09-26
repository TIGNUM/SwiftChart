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

    func didSelectContent(_ content: ContentCollection, category: ContentCategory, originFrame: CGRect, in viewController: LearnContentListViewController)

    func didTapBack(in viewController: LearnContentListViewController)
}

/// Displays a collection of items of learn content.
final class LearnContentListViewController: UIViewController {

    // MARK: - Properties

    fileprivate weak var pagingCollectionViewTopConstraint: NSLayoutConstraint?
    fileprivate weak var pagingCollectionViewBottomConstraint: NSLayoutConstraint?
    fileprivate weak var getBackButtonBottomConstraint: NSLayoutConstraint?
    fileprivate let disposeBag = DisposeBag()
    fileprivate lazy var collectionViewLayout = LearnStrategyListLayout()
    fileprivate var firstLaunch = true

    let viewModel: LearnContentCollectionViewModel
    var selectedCategoryIndex: Index
    weak var delegate: LearnContentListViewControllerDelegate?

    fileprivate lazy var pagingCellSize: CGSize = {
        return CGSize(width: self.view.frame.width / 2, height: 60)
    }()

    fileprivate lazy var performanceLabelSize: CGSize = {
        return CGSize(width: self.view.frame.width, height: 40)
    }()

    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            layout: self.collectionViewLayout,
            delegate: self,
            dataSource: self,
            dequeables: LearnContentCell.self
        )
        collectionView.contentInset = UIEdgeInsets(top:80, left: 0, bottom: 55, right: 0)
        return collectionView
    }()

    fileprivate lazy var carouselView: CarouselView = {
        let carouselView = CarouselView()
        carouselView.dataSource = self
        carouselView.delegate = self
        return carouselView
    }()

    fileprivate lazy var getBackButton: UIButton = {
        let viewFrame = self.view.bounds
        let button = UIButton(frame: CGRect(x: 0, y: viewFrame.height - Layout.TabBarView.height, width: viewFrame.width, height: Layout.TabBarView.height))
        button.setTitle(R.string.localized.learnContentTapToGetBack(), for: .normal)
        button.setTitleColor(Color.whiteMedium, for: .normal)
        button.titleLabel?.font = Font.H5SecondaryHeadline
        button.addTarget(self, action: #selector(didTapGetBack), for: .touchUpInside)

        return button
    }()

    fileprivate let backgroundImageView = UIImageView(image: R.image._1Learn())

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
        if firstLaunch {
            scrollToCategory(index: selectedCategoryIndex, animated: false)
            carouselView.scrollToItem(at: selectedCategoryIndex, animated: false)
            firstLaunch = false
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let cellWidth = view.bounds.width / 2
        let cellInset = view.bounds.width / 4
        carouselView.cellWidth = cellWidth
        carouselView.contentInset = UIEdgeInsets(top: 0, left: cellInset, bottom: 0, right: cellInset)
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

    func scrollToCategory(index: Int, animated: Bool) {
        guard
            let layout = collectionView.collectionViewLayout as? LearnStrategyListLayout,
            let minX = layout.minX(section: index) else {
                return
        }

        let offset = CGPoint(x: -collectionView.contentInset.left + minX - 20,
                             y: -collectionView.contentInset.top)
        collectionView.setContentOffset(offset, animated: animated)
    }

    func setupAppearance() {
        view.backgroundColor = .clear
        collectionView.backgroundColor = .clear
    }

    func setupHierachy() {
        view.addSubview(backgroundImageView)
        view.addSubview(collectionView)
        view.addSubview(carouselView)
        view.addSubview(getBackButton)
    }

    @objc func didTapGetBack() {
        delegate?.didTapBack(in: self)
    }

    func setupLayout() {
        backgroundImageView.edgeAnchors == view.edgeAnchors

        collectionView.topAnchor == view.topAnchor
        collectionView.bottomAnchor == view.bottomAnchor
        collectionView.horizontalAnchors == view.horizontalAnchors

        pagingCollectionViewTopConstraint = (carouselView.topAnchor == view.topAnchor + 20)
        pagingCollectionViewBottomConstraint = (carouselView.bottomAnchor == view.topAnchor + performanceLabelSize.height + pagingCellSize.height)
        carouselView.horizontalAnchors == view.horizontalAnchors

        getBackButtonBottomConstraint = (getBackButton.bottomAnchor == view.bottomAnchor)
        getBackButton.horizontalAnchors == view.horizontalAnchors
        getBackButton.heightAnchor == Layout.TabBarView.height

        view.layoutIfNeeded()
    }
}

// MARK: CarouselViewDataSource & CarouselViewDelegate

extension LearnContentListViewController: CarouselViewDataSource, CarouselViewDelegate {

    func numberOfItems(in carouselView: CarouselView) -> Int {
        return viewModel.categoryCount
    }

    func carouselView(_ carouselView: CarouselView, viewForItemAt index: Int, reusing existing: UIView?) -> UIView {
        let category = viewModel.category(at: index)

        let label: UILabel
        if let existing = (existing as? UILabel) {
            label = existing
        } else {
            label = UILabel()
            label.numberOfLines = 2
            label.textAlignment = .center
            label.font = Font.H5SecondaryHeadline
            label.textColor = .white
        }
        label.text = category.title.makingTwoLines().uppercased()

        return label
    }

    func carouselView(_ carouselView: CarouselView, didSelectItemAt index: Index) {
        carouselView.scrollToItem(at: index, animated: true)
        scrollToCategory(index: index, animated: true)
    }

    func carouselView(_ carouselView: CarouselView, didScrollToItemAt index: Index) {
        scrollToCategory(index: index, animated: true)
    }

    func carouselView(_ carouselView: CarouselView, styleView view: UIView, xPos: CGFloat) {
        let minAlpha: CGFloat = 0.2
        let maxOffset: CGFloat = 100
        view.alpha = max(maxOffset / abs(xPos), minAlpha)
    }
}

// MARK: UICollectionViewDataSource

extension LearnContentListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.categoryCount
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount(categoryIndex: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.item(at: indexPath)
        let cell: LearnContentCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: item, index: indexPath.item)

        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension LearnContentListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = viewModel.item(at: indexPath)
        let category = viewModel.category(at: indexPath.section)
        guard var originFrame = collectionView.cellForItem(at: indexPath)?.frame else { return }
        originFrame = collectionView.convert(originFrame, to: view)
        delegate?.didSelectContent(content, category: category, originFrame: originFrame, in: self)
    }
}

// MARK: UIScrollViewDelegate

extension LearnContentListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        undateSelectedCategoryIndex(scrollCarouselView: scrollView.isDragging)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        undateSelectedCategoryIndex(scrollCarouselView: true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        undateSelectedCategoryIndex(scrollCarouselView: true)
    }

    private func undateSelectedCategoryIndex(scrollCarouselView: Bool) {
        let center = CGPoint(x: collectionView.frame.midX, y: collectionView.frame.midY)
        let convertedCenter = view.convert(center, to: collectionView)

        guard let index = collectionView.indexPathForItem(at: convertedCenter)?.section else { return }

        if selectedCategoryIndex != index, firstLaunch == false {
            selectedCategoryIndex = index
            if scrollCarouselView == true {
                carouselView.scrollToItem(at: index, animated: true)
            }
        }
    }
}

// MARK: - ZoomPresentationAnimatable

extension LearnContentListViewController: ZoomPresentationAnimatable {
    func startAnimation(presenting: Bool, animationDuration: TimeInterval, openingFrame: CGRect) {

        let pagingTopConstraint = performanceLabelSize.height + pagingCellSize.height
        let pagingBottomConstraint = performanceLabelSize.height + pagingCellSize.height
        pagingCollectionViewTopConstraint?.constant = presenting ? -pagingTopConstraint : 0
        pagingCollectionViewBottomConstraint?.constant = presenting ? 0 : pagingBottomConstraint

        let bottomConstraint = Layout.TabBarView.height
        getBackButtonBottomConstraint?.constant = presenting ? bottomConstraint : 0

        self.view.layoutIfNeeded()

        UIView.transition(with: self.view, duration: animationDuration, options: [.allowAnimatedContent, .curveEaseOut], animations: {

            self.pagingCollectionViewTopConstraint?.constant = presenting ? 0 : -pagingTopConstraint
            self.pagingCollectionViewBottomConstraint?.constant = presenting ? pagingBottomConstraint : 0
            self.getBackButtonBottomConstraint?.constant = presenting ? 0 : bottomConstraint

            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
