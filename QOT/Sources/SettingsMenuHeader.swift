//
//  SettingsMenuHeader.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 24/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol SettingsMenuHeaderDelegate: class {
    func didTapImage(in view: SettingsMenuHeader?)
}

final class SettingsMenuHeader: UIView {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    private var viewModel: SettingsMenuViewModel?
    weak var delegate: SettingsMenuHeaderDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        setupImage()
    }

    func configure(imageURL: URL?, position: String, viewModel: SettingsMenuViewModel) {
        self.viewModel = viewModel
        updateUserName()
        updateJobTitle(title: position)
        userImageView.kf.setImage(with: imageURL, placeholder: R.image.placeholder_user())
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

// MARK: - Private

private extension SettingsMenuHeader {

    func setupImage() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(didTapImage))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
        userImageView.corner(radius: Layout.CornerRadius.eight.rawValue)
    }

    @objc func didTapImage() {
        delegate?.didTapImage(in: self)
    }
}
