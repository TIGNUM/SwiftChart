//
//  SettingsMenuHeader.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 24/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol SettingsMenuHeaderDelegate: class {
    func didTapImage(in view: SettingsMenuHeader)
}

final class SettingsMenuHeader: UIView {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var viewModel: SettingsMenuViewModel?
    weak var delegate: SettingsMenuHeaderDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        setupImage()
        setupCollectionView()
    }

    func configure(imageURL: URL?, position: String, viewModel: SettingsMenuViewModel) {
        self.viewModel = viewModel
        updateUserName()
        updateJobTitle(title: position)
        userImageView.kf.setImage(with: imageURL,
                                  placeholder: R.image.placeholder_user(),
                                  options: nil,
                                  progressBlock: nil,
                                  completionHandler: nil)
    }

    func updateLocalImage(image: UIImage) {
        self.userImageView.image = image
    }

    func updateJobTitle(title: String) {
        self.positionLabel.text = viewModel?.userJobTitle
    }

    func updateUserName() {
        nameLabel.text = viewModel?.userFirstName
        lastNameLabel.text = viewModel?.userLastName
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SettingsMenuHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tileCount = viewModel?.tileCount else { return 2 }
        return tileCount
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120.9, height: 119)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel?.tile(at: indexPath.row)
        let cell: SettingsMenuCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        if let title = item?.title, let subtitle = item?.subtitle {
            cell.setup(with: title, subTitle: subtitle)
        }

        return cell
    }
}

// MARK: - Private

private extension SettingsMenuHeader {

    func setupImage() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(didTapImage))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
        userImageView.layer.cornerRadius = 10
        userImageView.layer.masksToBounds = true
    }

    func setupCollectionView() {
        collectionView.registerDequeueable(SettingsMenuCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 29, bottom: 0, right: 29)
    }

    @objc func didTapImage() {
        delegate?.didTapImage(in: self)
    }
}
