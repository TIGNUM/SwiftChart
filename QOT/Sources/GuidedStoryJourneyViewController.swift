//
//  GuidedStoryJourneyViewController.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStoryJourneyViewController: UIViewController {

    var interactor: GuidedStoryJourneyInteractorInterface!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var headerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

// MARK: - GuidedStoryJourneyViewControllerInterface
extension GuidedStoryJourneyViewController: GuidedStoryJourneyViewControllerInterface {
    func setupView() {
        setupCollectionView()
    }

    func setupHeaderView(title: String?, imageURL: URL?, color: UIColor) {
        headerLabel.text = title
        headerImageView.kf.setImage(with: imageURL)
        view.backgroundColor = color
    }
}

// MARK: - Private
private extension GuidedStoryJourneyViewController {
    func setupCollectionView() {
        collectionView.registerDequeueable(TextCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension GuidedStoryJourneyViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension GuidedStoryJourneyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactor.itemCount
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TextCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let title = interactor.body(at: indexPath.item)
        cell.configure(title: title)
        cell.backgroundColor = .random
        return cell
    }
}
