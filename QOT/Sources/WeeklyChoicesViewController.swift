//
//  WeeklyChoicesViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol WeeklyChoicesViewControllerDelegate: class {

    func weeklyChoicesViewController(_ viewController: WeeklyChoicesViewController, didTapClose: Bool, animated: Bool)

    func weeklyChoicesViewController(_ viewController: WeeklyChoicesViewController,
                                     didUpdateListWithViewData viewData: WeeklyChoicesViewData)
}

final class WeeklyChoicesViewController: UIViewController, PageViewControllerNotSwipeable {

    // MARK: - Properties

    weak var delegate: WeeklyChoicesViewControllerDelegate?
    var viewData: WeeklyChoicesViewData {
        didSet {
            reload()
        }
    }
    private weak var circleLayer: CALayer?
    private lazy var layout = WeeklyChoicesLayout()
    private lazy var collectionView: UICollectionView = {
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
                          font: .DPText,
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        redraw()
    }

    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        redraw()
    }

    func reload() {
        collectionView.reloadData()
        setNoContentLabel()
        delegate?.weeklyChoicesViewController(self, didUpdateListWithViewData: viewData)
    }
}

// MARK: - Private

private extension WeeklyChoicesViewController {

    func redraw() {
        layout.circle = WeeklyChoicesLayout.Circle(center: CGPoint(x: -collectionView.bounds.size.width * Layout.multiplier_065,
																   y: collectionView.center.y),
												   radius: collectionView.bounds.size.width)
        layout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / CGFloat(5))
        layout.invalidateLayout()
        circleLayer?.removeFromSuperlayer()
        circleLayer = draw(layout.circle)
    }

    func setupView() {
        view.addSubview(collectionView)
        view.backgroundColor = .navy
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
			collectionView.topAnchor == view.safeTopAnchor + Layout.padding_20
			collectionView.horizontalAnchors == view.horizontalAnchors
		} else {
			collectionView.topAnchor == view.topAnchor + Layout.statusBarHeight
			collectionView.leftAnchor == view.leftAnchor
			collectionView.rightAnchor == view.rightAnchor
		}
		collectionView.bottomAnchor == view.bottomAnchor
        setNoContentLabel()
        view.layoutIfNeeded()
    }

    func setNoContentLabel() {
        if viewData.items.count == 0 {
            view.addSubview(emptyLabel)
            emptyLabel.edgeAnchors == view.edgeAnchors
            circleLayer?.removeFromSuperlayer()
            view.layoutIfNeeded()
        } else {
            emptyLabel.removeFromSuperview()
            if circleLayer?.superlayer == nil {
                circleLayer = draw(layout.circle)
            }
        }
    }

    func draw(_ circle: WeeklyChoicesLayout.Circle) -> CALayer? {
        return view.drawSolidCircle(
            arcCenter: circle.center,
            radius: circle.radius,
            strokeColor: .white20
        )
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension WeeklyChoicesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewData.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WeeklyChoicesCell = collectionView.dequeueCell(for: indexPath)
        let item = viewData.items[indexPath.row]
        cell.setUp(
            title: item.title ?? R.string.localized.meSectorMyWhyWeeklyChoicesNoChoiceTitle(),
            subTitle: item.categoryName ?? "",
            choice: item.subtitle ?? ""
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewData.items[indexPath.row]
        if let contentCollectionID = item.contentCollectionID {
            AppDelegate.current.appCoordinator.presentLearnContentItems(contentID: contentCollectionID)
        }
    }
}
