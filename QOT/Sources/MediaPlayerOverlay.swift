//
//  MediaPlayerOverlay.swift
//  QOT
//
//  Created by karmic on 30.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MediaPlayerOverlayDelegate: class {
    func showAlert()
}

final class MediaPlayerOverlay: UIView {

    // MARK: - Properties

    @IBOutlet private weak var downloadButton: UIButton!
    @IBOutlet private weak var bookmarkButton: UIButton!
    weak var delegate: MediaPlayerOverlayDelegate?

    static func instantiateFromNib() -> MediaPlayerOverlay {
        guard let mediaPlayerOverlay = R.nib.mediaPlayerOverlay.instantiate(withOwner: self).first as? MediaPlayerOverlay else {
            fatalError("Cannot load media player overlay view")
        }
        return mediaPlayerOverlay
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func configure() {

    }
}

// MARK: - Private

private extension MediaPlayerOverlay {
    func setupView() {
        downloadButton.corner(radius: 20)
        bookmarkButton.corner(radius: 20)
        bookmarkButton.layer.borderWidth = 1
        bookmarkButton.layer.borderColor = UIColor.accent30.cgColor
    }
}

// MARK: - Actions

private extension MediaPlayerOverlay {
    @IBAction func didTabDownloadButton() {
        delegate?.showAlert()
    }

    @IBAction func didTabBookmarkButton() {
        delegate?.showAlert()
    }
}
