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
    @IBOutlet private weak var velocityButton: RoundedButton!

    var media: MediaPlayerModel?
    var contentItem: QDMContentItem?
    var bookmarks: [QDMUserStorage]?
    var download: QDMUserStorage?
    var wasBookmarked: Bool = false
    private var colorMode: ColorMode = .dark
    private var velocity = Float(1.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didStartAudio(_:)), name: .didStartAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didPauseAudio(_:)), name: .didPauseAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didStopAudio(_:)), name: .didStopAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didEndAudio(_:)), name: .didEndAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didUpdateDownloadStatus(_:)),
                                       name: .didUpdateDownloadStatus, object: nil)

        (colorMode == .dark) ? NewThemeView.dark.apply(view) : NewThemeView.light.apply(view)
        setupButtons()
        updateLabel()
        setupFullScreenCircles(colorMode: self.colorMode)
        wasBookmarked = false
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
        styleVelocityButton()
        downloadButton.setImage(R.image.ic_save(), for: .normal)
        downloadButton.setImage(R.image.ic_download(), for: .disabled)
        bookmarkButton.setImage(R.image.ic_bookmark(), for: .normal)
        bookmarkButton.setImage(R.image.ic_bookmark_fill(), for: .selected)

        switch colorMode {
        case .dark:
            closeButton.setImage(R.image.arrowDown(), for: .normal)
            ThemeTint.white.apply(closeButton.imageView ?? UIImageView.init())
            ThemeTint.white.apply(downloadButton.imageView ?? UIImageView.init())
            ThemeTint.white.apply(bookmarkButton.imageView ?? UIImageView.init())
            ThemableButton.fullscreenAudioPlayerDownload.apply(bookmarkButton, title: nil)
            ThemableButton.fullscreenAudioPlayerDownload.apply(downloadButton, title: nil)
        case .darkNot:
            closeButton.setImage(R.image.arrowDown(), for: .normal)
            ThemeTint.black.apply(closeButton.imageView ?? UIImageView.init())
            ThemeTint.black.apply(downloadButton.imageView ?? UIImageView.init())
            ThemeTint.black.apply(bookmarkButton.imageView ?? UIImageView.init())
            ThemableButton.fullscreenAudioPlayerDownloadLight.apply(bookmarkButton, title: nil)
            ThemableButton.fullscreenAudioPlayerDownloadLight.apply(downloadButton, title: nil)
        }
    }

    func updateLabel() {
        switch colorMode {
        case.dark:
            ThemeText.articleCategoryNotScaled.apply(media?.subtitle, to: categorytitleLabel)
            ThemeText.audioFullScreenTitleDark.apply((media?.title ?? ""), to: titleLabel)
        case .darkNot:
            ThemeText.audioFullScreenCategory.apply(media?.subtitle, to: categorytitleLabel)
            ThemeText.audioFullScreenTitle.apply((media?.title ?? ""), to: titleLabel)
        }
    }

    func updatePlayButton(_ isPlaying: Bool) {
        playPauseButton.isSelected = isPlaying
    }

    func set(colorMode: ColorMode) {
        self.colorMode = colorMode
    }

    func styleVelocityButton() {
        velocityButton.circle()
        switch colorMode {
        case .dark:
            velocityButton.backgroundColor = .black
            velocityButton.layer.borderWidth = 1
            velocityButton.setTitleColor(.white, for: .normal)
            velocityButton.layer.borderColor = UIColor.white.cgColor
        case .darkNot:
            velocityButton.backgroundColor = .white
            velocityButton.layer.borderWidth = 1
            velocityButton.setTitleColor(.black, for: .normal)
            velocityButton.layer.borderColor = UIColor.black.cgColor
        }
    }

    func configureMedia(_ media: MediaPlayerModel, isPlaying: Bool = true) {
        self.media = media
        if self.view != nil {
            updatePlayButton(isPlaying)
            updateLabel()
        }
        ContentService.main.getContentItemById(media.mediaRemoteId) { [weak self] (item) in
            self?.contentItem = item
            self?.bookmarks = self?.contentItem?.userStorages?.filter({ (storage) -> Bool in
                storage.userStorageType == .BOOKMARK
            })
            self?.bookmarkButton.isSelected = self?.bookmarks?.first != nil
            self?.updateBookmarkButtonUI(self?.bookmarkButton.isSelected ?? false)
            self?.download = self?.contentItem?.userStorages?.filter({ (storage) -> Bool in
                storage.userStorageType == .DOWNLOAD
            }).first
            self?.updateDownloadButtonState(self?.download?.downloadStaus ?? .NONE)
        }
    }

    func updateDownloadButtonState(_ state: UserStorageDownloadStatus) {
        var title = AppTextService.get(.generic_download_status_audio_button_download)
        switch state {
        case .NONE:
            title = AppTextService.get(.generic_download_status_audio_button_download)
        case .WAITING:
            title = AppTextService.get(.my_qot_my_library_downloads_download_status_button_waiting)
        case .DOWNLOADING:
            title = AppTextService.get(.generic_download_status_audio_button_downloading)
        case .DONE:
            title = AppTextService.get(.generic_download_status_audio_button_downloaded)
            downloadButton.isEnabled = false
            downloadButton.layer.borderWidth = 0
            switch colorMode {
            case .dark:
                downloadButton.imageView?.tintColor = .black
            case .darkNot:
                downloadButton.imageView?.tintColor = .white
            }
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
        if !playPauseButton.isSelected {
            NotificationCenter.default.post(name: .setRateAudio, object: velocity)
        }
        trackUserEvent(playPauseButton.isSelected ? .PAUSE : .PLAY,
                       value: media?.mediaRemoteId, valueType: .AUDIO, action: .TAP)
    }

    @IBAction func didTapBookmarkButton() {
        trackUserEvent(.BOOKMARK, value: media?.mediaRemoteId, valueType: .AUDIO, action: .TAP)
        guard let itemId = contentItem?.remoteID, itemId != 0 else { return }
        TeamService.main.getTeams { [weak self] (teams, _, _) in
            if let teams = teams, teams.isEmpty == false {
                self?.showBookmarkSelectionViewController(with: itemId, { (_) in
                    self?.updateBookmarkButtonState()
                })
            } else {
                self?.toggleSingleBookmark()
            }
        }
    }

    private func showBookmarkSelectionViewController(with contentItemId: Int, _ completion: @escaping (Bool) -> Void) {
        guard let viewController = R.storyboard.bookMarkSelection.bookMarkSelectionViewController() else { return }
        let config = BookMarkSelectionConfigurator.make(contentId: contentItemId, contentType: .CONTENT_ITEM)
        config(viewController) { [weak self] (isChanged) in
            self?.trackPage()
            completion(isChanged)
            self?.refreshBottomNavigationItems()
        }
        present(viewController, animated: true, completion: nil)
    }

    private func toggleSingleBookmark() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        if let currentBookmark = bookmarks?.first {
            dispatchGroup.enter()
            UserStorageService.main.deleteUserStorage(currentBookmark) { (error) in
                if let error = error {
                    log("failed to remove bookmark: \(error)", level: .info)
                }
                dispatchGroup.leave()
            }
        } else if let item = contentItem {
            dispatchGroup.enter()
            UserStorageService.main.addBookmarkContentItem(item) {(_, error) in
                if let error = error {
                    log("failed to add bookmark: \(error)", level: .info)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.leave()
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.updateBookmarkButtonState()
        }
    }

    private func updateBookmarkButtonState() {
        guard let mediaId = media?.mediaRemoteId else { return }
        ContentService.main.getContentItemById(mediaId) { [weak self] (item) in
            self?.contentItem = item
            self?.bookmarks = self?.contentItem?.userStorages?.filter({ (storage) -> Bool in
                storage.userStorageType == .BOOKMARK
            })
            self?.bookmarkButton.isSelected = self?.bookmarks?.first != nil
            self?.updateBookmarkButtonUI(self?.bookmarkButton.isSelected ?? false)
            if self?.bookmarkButton.isSelected == true, self?.wasBookmarked == false {
                self?.wasBookmarked = true
                self?.showDestinationAlert()
            }
        }
    }

    private func updateBookmarkButtonUI(_ selected: Bool) {
        switch self.colorMode {
        case .dark:
            selected ? ThemeTint.black.apply(self.bookmarkButton.imageView ?? UIImageView.init()) :
                       ThemeTint.white.apply(self.bookmarkButton.imageView ?? UIImageView.init())
        default:
            selected ? ThemeTint.white.apply(self.bookmarkButton.imageView ?? UIImageView.init()) :
                       ThemeTint.black.apply(self.bookmarkButton.imageView ?? UIImageView.init())
        }
    }

    @IBAction func didTapDownloadButton() {
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

    @IBAction func didTapVelocity() {
        switch colorMode {
        case .dark:
            velocityButton.backgroundColor = .white
            velocityButton.layer.borderWidth = 1
            velocityButton.layer.borderColor = UIColor.black.cgColor
            velocityButton.setTitleColor(.black, for: .normal)
        case .darkNot:
            velocityButton.backgroundColor = .black
            velocityButton.layer.borderWidth = 1
            velocityButton.layer.borderColor = UIColor.white.cgColor
            velocityButton.setTitleColor(.white, for: .normal)
        }

        var title = ""
        switch velocity {
        case 0.5:
            styleVelocityButton()
            velocity = 1
            title = "1 X"
        case 1:
            velocity = 1.5
            title = "1.5 X"
        case 1.5:
            velocity = 2
            title = "2 X"
        case 2:
            velocity = 0.5
            title = "0.5 X"
        default:
            break
        }
        velocityButton.setTitle(title, for: .normal)
        trackUserEvent(.AUDIO_PLAYBACK_SPEED, stringValue: title, valueType: .AUDIO, action: .TAP)
        if playPauseButton.isSelected {
            NotificationCenter.default.post(name: .setRateAudio, object: velocity)
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

    func showDestinationAlert() {
        let closeButtonItem = createCloseButton(#selector(dismissAlert))
        QOTAlert.show(title: nil, message: AppTextService.get(.video_player_alert_added_to_library_body), bottomItems: [closeButtonItem])
    }

    @objc func dismissAlert() {
        QOTAlert.dismiss()
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
            case .DOWNLOADING: UserStorageService.main.deleteUserStorage(download) { [weak self] (_) in
                self?.updateDownloadButtonState(.NONE)
                self?.download = nil
                }
            default:
                self.updateDownloadButtonState(self.convertDownloadStatus(downloadStaus))
            }
        } else {
            UserStorageService.main.addToDownload(contentItem: item) { [weak self] (storage, _) in
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
            switch statusData.status {
            case .DOWNLOADED:
                showDestinationAlert()
            default:
                break
            }
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
