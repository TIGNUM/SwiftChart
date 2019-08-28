//
//  MediaPlayerOverlay.swift
//  QOT
//
//  Created by karmic on 30.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MediaPlayerOverlayDelegate: class {
    func downloadMedia()
    func bookmarkMedia()
}

final class MediaPlayerOverlay: UIView {

    // MARK: - Properties
    static let height: CGFloat = 40

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
        buttonsShowHide()
        addOrientationObserver()
    }

    private func addOrientationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeOrientation),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }

    func configure(downloadTitle: String, isBokmarked: Bool) {
        downloadButton.setTitle(downloadTitle, for: .normal)
        bookmarkButton.isSelected = isBokmarked
    }
}

// MARK: - Private

private extension MediaPlayerOverlay {
    func setupView() {
        downloadButton.corner(radius: 20)
        ThemeBorder.accentBackground.apply(bookmarkButton)
    }

    @objc func didChangeOrientation() {
        UIView.animate(withDuration: 0.1) {
            self.buttonsShowHide()
        }
    }

    func buttonsShowHide() {
        let alpha: CGFloat = UIDevice.current.orientation.isLandscape ? 0.0 : 1.0
        downloadButton.alpha = alpha
        bookmarkButton.alpha = alpha
    }
}

// MARK: - Actions

private extension MediaPlayerOverlay {
    @IBAction func didTapDownloadButton() {
        delegate?.downloadMedia()
    }

    @IBAction func didTapBookmarkButton() {
        delegate?.bookmarkMedia()
    }
}
