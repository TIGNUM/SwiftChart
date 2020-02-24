//
//  AudioFullScreenViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class AudioFullScreenViewController: BaseViewController, ScreenZLevel3 {

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var categorytitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var downloadButton: RoundedButton!
    @IBOutlet private weak var bookmarkButton: RoundedButton!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var fullScreenCircles: FullScreenBackgroundCircleView!

    var media: MediaPlayerModel?
    var contentItem: QDMContentItem?
    var bookmark: QDMUserStorage?
    var download: QDMUserStorage?
    private var colorMode: ColorMode = .dark

    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didStartAudio(_:)), name: .didStartAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didPauseAudio(_:)), name: .didPauseAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didStopAudio(_:)), name: .didStopAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didEndAudio(_:)), name: .didEndAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didUpdateDownloadStatus(_:)),
                                       name: .didUpdateDownloadStatus, object: nil)

        // FIXME : change color with color mode
        view.backgroundColor = (colorMode == .dark) ? .carbon : .sand
        setupButtons()
        updateLabel()
        setupFullScreenCircles(colorMode: self.colorMode)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    func setupFullScreenCircles(colorMode: ColorMode) {
        switch colorMode {
        case .dark:
            ThemeCircles.fullScreenAudioDark.apply(fullScreenCircles)
        case .darkNot:
            ThemeCircles.fullScreenAudioLight.apply(fullScreenCircles)
        }

    }

    func setupButtons() {
        switch colorMode {
        case .dark:
            ThemableButton.fullscreenAudioPlayerDownload.apply(bookmarkButton, title: nil)
        case .darkNot:
            ThemableButton.fullscreenAudioPlayerDownloadLight.apply(bookmarkButton, title: nil)
        }
    }

    func updateLabel() {
        ThemeText.articleCategoryNotScaled.apply(media?.subtitle, to: categorytitleLabel)
        ThemeText.articleTitleNotScaled.apply((media?.title ?? "").uppercased(), to: titleLabel)
    }

    func updatePlayButton(_ isPlaying: Bool) {
        playPauseButton.isSelected = isPlaying
    }

    func set(colorMode: ColorMode) {
        self.colorMode = colorMode
    }

    func configureMedia(_ media: MediaPlayerModel, isPlaying: Bool = true) {
        self.media = media
        if self.view != nil {
            updatePlayButton(isPlaying)
            updateLabel()
        }
        ContentService.main.getContentItemById(media.mediaRemoteId) { [weak self] (item) in
            self?.contentItem = item
            self?.bookmark = self?.contentItem?.userStorages?.filter({ (storage) -> Bool in
                storage.userStorageType == .BOOKMARK
            }).first
            self?.bookmarkButton.isSelected = self?.bookmark != nil
            self?.download = self?.contentItem?.userStorages?.filter({ (storage) -> Bool in
                storage.userStorageType == .DOWNLOAD
            }).first
            self?.updateDownloadButtonState(self?.download?.downloadStaus ?? .NONE)
        }
    }

    func updateDownloadButtonState(_ state: UserStorageDownloadStatus) {
        var title = AppTextService.get(.generic_download_status_audio_button_download)
        switch state {
        case .NONE: title = AppTextService.get(.generic_download_status_audio_button_download)
        case .WAITING: title = AppTextService.get(.my_qot_my_library_downloads_download_status_button_waiting)
        case .DOWNLOADING: title = AppTextService.get(.generic_download_status_audio_button_downloading)
        case .DONE:
            title = AppTextService.get(.generic_download_status_audio_button_downloaded)
            downloadButton.isEnabled = false
            downloadButton.layer.borderWidth = 0
        }

        switch colorMode {
        case .dark:
            ThemableButton.fullscreenAudioPlayerDownload.apply(downloadButton, title: title)
        case .darkNot:
            ThemableButton.fullscreenAudioPlayerDownloadLight.apply(downloadButton, title: title)
        }
    }

    func convertDownloadStatus(_ status: QOTDownloadStatus) -> UserStorageDownloadStatus {
        switch status {
        case .NONE: return .NONE
        case .WAITING: return .WAITING
        case .DOWNLOADING: return .DOWNLOADING
        case .DOWNLOADED: return .DONE
        }
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 0
        pageTrack.pageKey = pageKey
        pageTrack.associatedValueType = .CONTENT_ITEM
        pageTrack.associatedValueId = media?.mediaRemoteId
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

// MARK: - Actions
extension AudioFullScreenViewController {
    @IBAction func didTapCloseButton() {
        trackUserEvent(.CLOSE, value: media?.mediaRemoteId, valueType: .AUDIO, action: .TAP)
        NotificationCenter.default.post(name: .hideAudioFullScreen, object: media)
        self.dismiss(animated: true)
    }

    @IBAction func didSwipeDown() {
        trackUserEvent(.CLOSE, value: media?.mediaRemoteId, valueType: .AUDIO, action: .SWIPE)
        NotificationCenter.default.post(name: .hideAudioFullScreen, object: media)
        self.dismiss(animated: true)
    }

    @IBAction func didTapPlayPauseButton() {
        NotificationCenter.default.post(name: .playPauseAudio, object: media)
        trackUserEvent(playPauseButton.isSelected ? .PAUSE : .PLAY,
                       value: media?.mediaRemoteId, valueType: .AUDIO, action: .TAP)
    }

    @IBAction func didTapBookmarkButton() {
        trackUserEvent(.BOOKMARK, value: media?.mediaRemoteId, valueType: .AUDIO, action: .TAP)
        if let currentBookmark = bookmark {
            UserStorageService.main.deleteUserStorage(currentBookmark) { [weak self] (error) in
                if let error = error {
                    log("failed to remove bookmark: \(error)", level: .info)
                }
                NotificationCenter.default.post(name: .didUpdateMyLibraryData, object: nil)
                self?.bookmark = nil
                self?.bookmarkButton.isSelected = self?.bookmark != nil
                self?.bookmarkButton.isSelected ?? true ? (self?.bookmarkButton.layer.borderWidth = 0) : (self?.bookmarkButton.layer.borderWidth = 1)
            }
        } else if let item = contentItem {
            UserStorageService.main.addBookmarkContentItem(item) { [weak self] (storage, error) in
                if let error = error {
                    log("failed to add bookmark: \(error)", level: .info)
                }
                NotificationCenter.default.post(name: .didUpdateMyLibraryData, object: nil)
                self?.bookmark = storage
                self?.bookmarkButton.isSelected = self?.bookmark != nil
                self?.bookmarkButton.isSelected ?? true ? (self?.bookmarkButton.layer.borderWidth = 0) : (self?.bookmarkButton.layer.borderWidth = 1)
            }
        }
    }

    @IBAction func didTapDownloadButton() {
        self.downloadButton.layer.borderWidth = 0
        if download != nil {
            continueDownload()
            return
        }

        switch QOTReachability().status {
        case .ethernetOrWiFi:
            continueDownload()
        case .wwan:
            showMobileDataDownloadAlert()
        case .notReachable:
            showNoInternetConnectionAlert()
        }
    }
}

// Private methods

private extension AudioFullScreenViewController {

    func showMobileDataDownloadAlert() {
        let cancel = QOTAlertAction(title: AppTextService.get(.generic_view_button_cancel))
        let buttonContinue = QOTAlertAction(title: AppTextService.get(.generic_content_audio_alert_use_mobile_data_button_continue)) { [weak self] (_) in
            self?.continueDownload()
        }
        QOTAlert.show(title: AppTextService.get(.generic_content_audio_alert_use_mobile_data_title),
                      message: AppTextService.get(.generic_content_audio_alert_use_mobile_data_body),
                      bottomItems: [cancel, buttonContinue])
    }

    func continueDownload() {
        trackUserEvent(.DOWNLOAD, value: media?.mediaRemoteId, valueType: .AUDIO, action: .TAP)
        guard let item = contentItem else {
            return
        }

        if let download = self.download {
            let downloadStaus = UserStorageService.main.downloadStatus(for: download).status
            switch downloadStaus {
            case .NONE,
                 .WAITING: UserStorageService.main.resumeDownload(download) { [weak self] (status) in
                    self?.updateDownloadButtonState(self?.convertDownloadStatus(status) ?? .NONE)
                }
            case .DOWNLOADING: UserStorageService.main.deleteUserStorage(download) { [weak self] (error) in
                self?.updateDownloadButtonState(.NONE)
                self?.download = nil
                }
            default: self.updateDownloadButtonState(self.convertDownloadStatus(downloadStaus))
            }
        } else {
            UserStorageService.main.addToDownload(contentItem: item) { [weak self] (storage, error) in
                self?.download = storage
                self?.updateDownloadButtonState(storage?.downloadStaus ?? .NONE)
                guard let download = storage else {
                    return
                }
                UserStorageService.main.resumeDownload(download) { [weak self] (status) in
                    self?.updateDownloadButtonState(self?.convertDownloadStatus(status) ?? .NONE)
                }
            }
        }
    }
}

// MARK: - Notifications

extension AudioFullScreenViewController {
    @objc func didStartAudio(_ notification: Notification) {
        updatePlayButton(true)
    }

    @objc func didStopAudio(_ notification: Notification) {
        updatePlayButton(false)
        self.dismiss(animated: true)
    }

    @objc func didPauseAudio(_ notification: Notification) {
        updatePlayButton(false)
    }

    @objc func didEndAudio(_ notification: Notification) {
        updatePlayButton(false)
    }

    @objc func didUpdateDownloadStatus(_ notification: Notification) {
        guard let map = notification.object as? [String: QDMDownloadStatus] else {
            return
        }
        if let donwloadKey = self.download?.qotId, let statusData = map[donwloadKey] {
            updateDownloadButtonState(convertDownloadStatus(statusData.status))
        }
    }
}

// MARK: Bottom Navigation
extension AudioFullScreenViewController {

    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}
