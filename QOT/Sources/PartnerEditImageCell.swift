//
//  PartnerEditImageCell.swift
//  QOT
//
//  Created by karmic on 17.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnerEditImageCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var cameraImageView: UIImageView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var imageLabel: UILabel!
    private var interactor: PartnerEditInteractorInterface?

    // MARK: - Public

    func configure(imageURL: URL?, image: UIImage?, interactor: PartnerEditInteractorInterface?) {
        self.interactor = interactor
        if let imageURL = imageURL {
            profileImageView.kf.setImage(with: imageURL)
        }
        if let image = image {
            profileImageView.image = image
        }
    }
}

// MARK: - Actions

private extension PartnerEditImageCell {

    @IBAction func didTapImageButton() {
        interactor?.showImagePicker()
    }
}
