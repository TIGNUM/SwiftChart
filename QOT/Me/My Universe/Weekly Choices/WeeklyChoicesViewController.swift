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
    func didTapClose(in viewController: UIViewController, animated: Bool)
    func didTapShare(in viewController: UIViewController, from rect: CGRect, with item: WeeklyChoice)
}

final class WeeklyChoicesViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: WeeklyChoicesViewModel
    weak var delegate: WeeklyChoicesViewControllerDelegate?

    fileprivate lazy var collectionView: UICollectionView = {
        let layout = WeeklyChoicesLayout()
        layout.delegate = self

        return UICollectionView(
            layout: layout,
            delegate: self,
            dataSource: self,
            dequeables: WeeklyChoicesCell.self
        )
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
    }
}

// MARK: - Private

private extension WeeklyChoicesViewController {

    func setupView() {
        view.addSubview(collectionView)
        view.backgroundColor = .clear
        collectionView.topAnchor == view.topAnchor + Layout.TabBarView.height
        collectionView.bottomAnchor == view.bottomAnchor - Layout.TabBarView.height
        collectionView.horizontalAnchors == view.horizontalAnchors
        view.layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension WeeklyChoicesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.item(at: indexPath.item)
        let cell: WeeklyChoicesCell = collectionView.dequeueCell(for: indexPath)
        cell.setUp(title: item.title, subTitle: item.text, text: item.text)

        return cell
    }
}
// MARK: - Layout Delegate

extension WeeklyChoicesViewController: WeeklyChoicesDelegate {

    func radius(_: WeeklyChoicesLayout) -> CGFloat {
        return CGFloat(400)
    }

    func circleX(_: WeeklyChoicesLayout) -> CGFloat {
        return CGFloat(-330)
    }

    func cellSize(_: WeeklyChoicesLayout) -> CGSize {
        return CGSize(width: 300, height: 100)
    }
}
