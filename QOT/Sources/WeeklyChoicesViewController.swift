//
//  WeeklyChoicesViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import ReactiveKit

protocol WeeklyChoicesViewControllerDelegate: class {

    func didTapClose(in viewController: UIViewController, animated: Bool)

    func didTapShare(in viewController: UIViewController, from rect: CGRect, with item: WeeklyChoice)

    func didUpdateList(with viewModel: WeeklyChoicesViewModel)
}

final class WeeklyChoicesViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: WeeklyChoicesViewControllerDelegate?
    fileprivate let viewModel: WeeklyChoicesViewModel
    fileprivate lazy var dateLabel: UILabel = UILabel()
    private let disposeBag = DisposeBag()

    fileprivate lazy var collectionView: UICollectionView = {
        let layout = WeeklyChoicesLayout()
        layout.delegate = self

        return UICollectionView(layout: layout,
                                delegate: self,
                                dataSource: self,
                                dequeables: WeeklyChoicesCell.self)
    }()

    fileprivate lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white40
        label.numberOfLines = 0
        label.setAttrText(text: R.string.localized.weeklyChoicesNoContent(),
                          font: Font.DPText,
                          alignment: .center,
                          lineSpacing: 7,
                          characterSpacing: 1)
        return label
    }()

    // MARK: - Init

    init(viewModel: WeeklyChoicesViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        observeViewModel()
    }
}

// MARK: - Private

private extension WeeklyChoicesViewController {

    func observeViewModel() {
        viewModel.updates.observeNext { [collectionView] (update) in
            collectionView.reloadData()
            self.delegate?.didUpdateList(with: self.viewModel)
            self.setNoContentLabel()
        }.dispose(in: disposeBag)
    }

    func setupView() {
        let coverView = UIImageView(image: R.image.backgroundWeeklyChoices())
        coverView.contentMode = .scaleAspectFill
        view.addSubview(coverView)
        view.addSubview(collectionView)
        view.addSubview(dateLabel)
        view.backgroundColor = .clear
        dateLabel.topAnchor == view.topAnchor + 60
        dateLabel.horizontalAnchors == view.horizontalAnchors
        dateLabel.heightAnchor == 14
        collectionView.topAnchor == dateLabel.bottomAnchor
        collectionView.bottomAnchor == view.bottomAnchor
        collectionView.horizontalAnchors == view.horizontalAnchors
        coverView.topAnchor == view.topAnchor
        coverView.horizontalAnchors == view.horizontalAnchors
        coverView.bottomAnchor == view.bottomAnchor
        setNoContentLabel()
        view.layoutIfNeeded()
        configureDateLabel(dateLabel)
    }

    private func setNoContentLabel() {
        if viewModel.itemCount <= 0 {
            view.addSubview(emptyLabel)
            emptyLabel.horizontalAnchors == view.horizontalAnchors
            emptyLabel.verticalAnchors == view.verticalAnchors
        } else {
            emptyLabel.removeFromSuperview()
        }
    }

    func configureDateLabel(_ dateLabel: UILabel) {
        dateLabel.backgroundColor = .clear
        dateLabel.font = Font.H7Title
        dateLabel.textColor = .white50
        dateLabel.textAlignment = .center
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension WeeklyChoicesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WeeklyChoicesCell = collectionView.dequeueCell(for: indexPath)
        dateLabel.addCharactersSpacing(spacing: 2, text: viewModel.pageDates(forIndex: indexPath.item))

        if let item = viewModel.item(at: indexPath.item) {
            cell.setUp(title: item.title ?? "", subTitle: "", choice: viewModel.choiceNumber(forIndex: indexPath.item))
        } else {
            cell.setUp(title: R.string.localized.meSectorMyWhyWeeklyChoicesNoChoiceTitle(), subTitle: "", choice: "")
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel.item(at: indexPath.item) else { return }

        AppDelegate.current.appCoordinator.presentLearnContentItems(contentID: item.contentCollectionID, categoryID: item.categoryID)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            changePage(scrollView: scrollView)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changePage(scrollView: scrollView)
    }

    private func changePage(scrollView: UIScrollView) {
        let changeOffset = CGFloat(cellSize().height) * CGFloat(viewModel.itemsPerWeek) / 3
        let pageHeight = CGFloat(cellSize().height) * CGFloat(viewModel.itemsPerWeek)
        let currentOffset: CGFloat = scrollView.contentOffset.y
        var targetOffset: CGFloat = 0
        var index = Int(fabs(currentOffset) / pageHeight)
        let remainingOffset = fabs(currentOffset).truncatingRemainder(dividingBy: pageHeight)

        if remainingOffset > changeOffset {
            index += 1
        }

        index = index < 0 ? 0 : index >= viewModel.itemCount ? viewModel.itemCount - 1 : index
        targetOffset = pageHeight * CGFloat(index)
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: targetOffset), animated: true)
    }
}
// MARK: - Layout Delegate

extension WeeklyChoicesViewController: WeeklyChoicesDelegate {

    func radius() -> CGFloat {
        return CGFloat(400)
    }

    func circleX() -> CGFloat {
        return CGFloat(-330)
    }

    func cellSize() -> CGSize {
        return CGSize(width: 300, height: collectionView.frame.height / 5.5)
    }
}

// MARK: - CustomPresentationAnimatorDelegate

extension WeeklyChoicesViewController: CustomPresentationAnimatorDelegate {
    func animationsForAnimator(_ animator: CustomPresentationAnimator) -> (() -> Void)? {
        view.alpha = animator.isPresenting ? 0.0 : 1.0
        parent?.view.alpha = animator.isPresenting ? 0.0 : 1.0
        return { [unowned self] in
            self.view.alpha = animator.isPresenting ? 1.0 : 0.0
            self.parent?.view.alpha = animator.isPresenting ? 1.0 : 0.0
        }
    }
}
