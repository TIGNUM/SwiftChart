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
    var buttonsHidden: Bool? = false

    static func instantiateFromNib() -> MediaPlayerOverlay {
        guard let mediaPlayerOverlay = R.nib.mediaPlayerOverlay.instantiate(withOwner: self).first as? MediaPlayerOverlay else {
            fatalError("Cannot load media player overlay view")
        }
        return mediaPlayerOverlay
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        buttonsForScreen()
        addOrientationObserver()
    }

    private func addOrientationObserver() {
        _ = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didChangeOrientation()
        }
    }

    func configure(downloadTitle: String, isBokmarked: Bool, isDownloaded: Bool) {
        ThemableButton.fullscreenVideoPlayerDownload.apply(downloadButton, title: downloadTitle)
        downloadButton.isEnabled = !isDownloaded
        bookmarkButton.isSelected = isBokmarked
        isBokmarked ? ThemeTint.black.apply(bookmarkButton) : ThemeTint.white.apply(bookmarkButton)
    }

    func buttonsForScreen() {
        var hidden = UIDevice.current.orientation.isLandscape
        if let avPlayerViewController = delegate as? AVPlayerViewController,
            avPlayerViewController.videoGravity.rawValue == AVLayerVideoGravity.resizeAspectFill.rawValue {
            hidden = true
        }
        let alpha: CGFloat = hidden ? 0.0 : 1.0
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.downloadButton.alpha = alpha
            self?.bookmarkButton.alpha = alpha
            self?.buttonsHidden = hidden
        }
    }

    func buttonsShow() {
        guard buttonsHidden == true else { return }
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.downloadButton.alpha = 1
            self?.bookmarkButton.alpha = 1
            self?.buttonsHidden?.toggle()
        }
    }

    func buttonsHide() {
        self.buttonsHidden = false
        UIView.animate(withDuration: 0.2, delay: 3, options: [], animations: {
                        self.downloadButton.alpha = 0
                        self.bookmarkButton.alpha = 0 }, completion: { (completed) in
                            self.buttonsHidden = true
                        })
    }

    func buttonsAnimate() {
        UIView.animate(withDuration: 0.2, delay: 0.3, options: [], animations: {
                        self.downloadButton.alpha = 1
                        self.bookmarkButton.alpha = 1
                        self.buttonsHidden = false }, completion: { (completed) in
                            UIView.animate(withDuration: 0.2, delay: 3, options: [], animations: {
                                            self.downloadButton.alpha = 0
                                            self.bookmarkButton.alpha = 0 }, completion: { (completed) in
                                                self.buttonsHidden = true
                                            })
                        })
    }
}

// MARK: - Private

private extension MediaPlayerOverlay {
    func setupView() {
        ThemableButton.fullscreenVideoPlayerDownload.apply(bookmarkButton, title: nil)
    }

    @objc func didChangeOrientation() {
        self.buttonsForScreen()
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
