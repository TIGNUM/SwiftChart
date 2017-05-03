//
//  WhatsHotViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol WhatsHotViewControllerDelegate: class {
    func didTapVideo(at index: Index, with whatsHot: WhatsHotItem, from view: UIView, in viewController: WhatsHotViewController)
    func didTapBookmark(at index: Index, with whatsHot: WhatsHotItem, in view: UIView, in viewController: WhatsHotViewController)
}

class WhatsHotViewController: UIViewController {

    // MARK: - Properties / Outlets

    @IBOutlet private weak var collectionView: UICollectionView!
    let viewModel: WhatsHotViewModel
    weak var delegate: WhatsHotViewControllerDelegate?
    weak var topTabBarScrollViewDelegate: TopTabBarScrollViewDelegate?

    // MARK: - Life Cycle

    init(viewModel: WhatsHotViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        setUpCollectionView()
    }

    func setUpCollectionView() {
        let layout = WhatsHotLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.registerDequeueable(WhatsHotCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension WhatsHotViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.item(at: indexPath.item)
        let cell: WhatsHotCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: item)

        return cell
    }
}

// MARK: - WhatsHotLayoutDelegate

extension WhatsHotViewController: WhatsHotLayoutDelegate {

    func standardHeightForLayout(_ layout: WhatsHotLayout) -> CGFloat {
        return 130
    }

    func featuredHeightForLayout(_ layout: WhatsHotLayout) -> CGFloat {
        let nonPictureHeight: CGFloat = 130
        let nonPictureWidth: CGFloat = 92
        let pictureRatio: CGFloat = 1.5
        let pictureHeight = (view.bounds.width - nonPictureWidth) / pictureRatio

        return pictureHeight + nonPictureHeight
    }
}

// MARK: - UIScrollViewDelegate

extension WhatsHotViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            let alpha = abs(scrollView.contentOffset.y) / 64
            topTabBarScrollViewDelegate?.didScrollUnderTopTabBar(alpha: alpha)
        }
    }
}
