//
//  MediaPlayerOverlay.swift
//  QOT
//
//  Created by karmic on 30.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import AVKit

protocol MediaPlayerOverlayDelegate: class {
    func downloadMedia()
    func bookmarkMedia()
}

final class MediaPlayerOverlay: UIView {

    // MARK: - Properties
    static let height: CGFloat = 40

    @IBOutlet private weak var downloadButton: RoundedButton!
    @IBOutlet private weak var bookmarkButton: RoundedButton!
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

    func configure(downloadTitle: String, isBokmarked: Bool, isDownloaded: Bool) {
        ThemableButton.fullscreenVideoPlayerDownload.apply(downloadButton, title: downloadTitle)
        downloadButton.isEnabled = !isDownloaded
        bookmarkButton.isSelected = isBokmarked
    }

    func buttonsShowHide() {
        var hidden = UIDevice.current.orientation.isLandscape
        if let avPlayerViewController = delegate as? AVPlayerViewController,
            avPlayerViewController.videoGravity == AVLayerVideoGravity.resizeAspectFill.rawValue {
            hidden = true
        }
        let alpha: CGFloat = hidden ? 0.0 : 1.0
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.downloadButton.alpha = alpha
            self?.bookmarkButton.alpha = alpha
        }
    }
}

// MARK: - Private

private extension MediaPlayerOverlay {
    func setupView() {
        ThemableButton.fullscreenVideoPlayerDownload.apply(bookmarkButton, title: nil)
    }

    @objc func didChangeOrientation() {
        self.buttonsShowHide()
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
