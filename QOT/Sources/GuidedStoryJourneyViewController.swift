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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension GuidedStoryJourneyViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension GuidedStoryJourneyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
