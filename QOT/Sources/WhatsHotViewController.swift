//
//  WhatsHotViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol WhatsHotViewControllerDelegate: class {
    func didTapVideo(at index: Index, with whatsHot: LearnWhatsHotContentItem, from view: UIView, in viewController: WhatsHotViewController)
    func didTapBookmark(at index: Index, with whatsHot: LearnWhatsHotContentItem, in view: UIView, in viewController: WhatsHotViewController)
}

class WhatsHotViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: WhatsHotViewModel
    weak var delegate: WhatsHotViewControllerDelegate?
    let theme: Theme = .dark
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = WhatsHotLayout()
        layout.delegate = self

        return UICollectionView(
            layout: layout,
            delegate: self,
            dataSource: self,
            dequeables: WhatsHotCell.self
        )
    }()

    // MARK: Init

    init(viewModel: WhatsHotViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
}

// MARK: - Private

extension WhatsHotViewController {

    func setupLayout() {
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.topAnchor == view.topAnchor
        collectionView.heightAnchor == view.heightAnchor - Layout.TabBarView.height
        collectionView.horizontalAnchors == view.horizontalAnchors
        view.layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource

extension WhatsHotViewController: UICollectionViewDataSource, UICollectionViewDelegate {

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
