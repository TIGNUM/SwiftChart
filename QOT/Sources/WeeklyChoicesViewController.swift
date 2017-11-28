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

    func weeklyChoicesViewController(_ viewController: WeeklyChoicesViewController, didTapClose: Bool, animated: Bool)
    func weeklyChoicesViewController(_ viewController: WeeklyChoicesViewController, didUpdateListWithViewData viewData: WeeklyChoicesViewData)
}

final class WeeklyChoicesViewController: UIViewController, PageViewControllerNotSwipeable {

    // MARK: - Properties

    weak var delegate: WeeklyChoicesViewControllerDelegate?
    var viewData: WeeklyChoicesViewData {
        didSet {
            reload()
        }
    }
    private lazy var dateLabel: UILabel = UILabel()
    private weak var circleLayer: CALayer?
    private let disposeBag = DisposeBag()
    private lazy var collectionView: UICollectionView = {
        let layout = WeeklyChoicesLayout()
        layout.delegate = self
        return UICollectionView(layout: layout,
                                delegate: self,
                                dataSource: self,
                                dequeables: WeeklyChoicesCell.self)
    }()
    private lazy var emptyLabel: UILabel = {
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

    init(viewData: WeeklyChoicesViewData) {
        self.viewData = viewData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        circleLayer?.removeFromSuperlayer()
        circleLayer = drawCircle()
    }
    
    func reload() {
        collectionView.reloadData()
        setNoContentLabel()
        delegate?.weeklyChoicesViewController(self, didUpdateListWithViewData: viewData)
    }
}

// MARK: - Private

private extension WeeklyChoicesViewController {

    func setupView() {
        let coverView = UIImageView(image: R.image.backgroundWeeklyChoices())
        coverView.contentMode = .scaleAspectFill
        view.addSubview(coverView)
        view.addSubview(collectionView)
        view.addSubview(dateLabel)
        view.backgroundColor = .clear
        dateLabel.topAnchor == view.safeTopAnchor
        dateLabel.horizontalAnchors == view.horizontalAnchors
        dateLabel.heightAnchor == 14
        collectionView.topAnchor == dateLabel.bottomAnchor + 15
        collectionView.bottomAnchor == view.bottomAnchor
        collectionView.horizontalAnchors == view.horizontalAnchors
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        coverView.edgeAnchors == view.edgeAnchors
        setNoContentLabel()
        configureDateLabel(dateLabel)
        
        view.layoutIfNeeded()
        view.setFadeMask(at: .bottom)
    }

    func setNoContentLabel() {
        if viewData.pages.count == 0 {
            view.addSubview(emptyLabel)
            emptyLabel.edgeAnchors == view.edgeAnchors
            circleLayer?.removeFromSuperlayer()
            view.layoutIfNeeded()
        } else {
            emptyLabel.removeFromSuperview()
            if circleLayer?.superlayer == nil {
                circleLayer = drawCircle()
            }
        }
    }

    func configureDateLabel(_ dateLabel: UILabel) {
        dateLabel.backgroundColor = .clear
        dateLabel.font = Font.H7Title
        dateLabel.textColor = .white50
        dateLabel.textAlignment = .center
        if let text = viewData.pages.first?.dateString {
            updateDate(text)
        }
    }
    
    func drawCircle() -> CALayer? {
        let layout = WeeklyChoicesLayout()
        var center = layout.circleCenter(circleX: circleX(), collectionView: collectionView)
        center.x += 33 // FIXME: sorry for the magic number. not sure why this is needed :(
        center.y = collectionView.center.y + (view.safeMargins.top / 2.0)
        return view.drawSolidCircle(
            arcCenter: center,
            radius: radius(),
            strokeColor: .white20
        )
    }
    
    func snapPage(scrollView: UIScrollView) {
        let itemsPerPage = viewData.itemsPerPage
        let changeOffset = cellHeight() * CGFloat(itemsPerPage) / 3
        let pageHeight = cellHeight() * CGFloat(itemsPerPage)
        let currentOffset: CGFloat = scrollView.contentOffset.y
        var targetOffset: CGFloat = 0
        var index = Int(fabs(currentOffset) / pageHeight)
        let remainingOffset = fabs(currentOffset).truncatingRemainder(dividingBy: pageHeight)
        if remainingOffset > changeOffset {
            index += 1
        }
        index = index < 0 ? 0 : index >= itemsPerPage ? itemsPerPage - 1 : index
        targetOffset = pageHeight * CGFloat(index)
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: targetOffset), animated: true)
        updateDate(viewData.pages[index].dateString)
    }
    
    func updateDate(_ text: String) {
        dateLabel.addCharactersSpacing(spacing: 2, text: text)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension WeeklyChoicesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewData.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewData[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WeeklyChoicesCell = collectionView.dequeueCell(for: indexPath)
        let item = viewData[indexPath.section][indexPath.row]
        cell.setUp(
            title: item.title ?? R.string.localized.meSectorMyWhyWeeklyChoicesNoChoiceTitle(),
            subTitle: item.categoryName ?? "",
            choice: item.subtitle ?? ""
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewData[indexPath.section][indexPath.row]
        guard let contentCollectionID = item.contentCollectionID, let categoryID = item.categoryID else {
            return
        }
        AppDelegate.current.appCoordinator.presentLearnContentItems(contentID: contentCollectionID, categoryID: categoryID)
    }
}

// MARK: - UIScrollViewDelegate

extension WeeklyChoicesViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snapPage(scrollView: scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapPage(scrollView: scrollView)
    }
}

// MARK: - WeeklyChoicesLayoutDelegate

extension WeeklyChoicesViewController: WeeklyChoicesLayoutDelegate {

    func radius() -> CGFloat {
        return CGFloat(400)
    }

    func circleX() -> CGFloat {
        return CGFloat(-330)
    }

    func cellHeight() -> CGFloat {
        return collectionView.frame.height / 5.5
    }
}
