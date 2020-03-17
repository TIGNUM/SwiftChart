//
//  BaseRootViewController+BottomNavigation.swift
//  QOT
//
//  Created by Sanggeon Park on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

extension BaseRootViewController {
    func currentBottomNavigationItem() -> BottomNavigationItem? {
        return lastestBottomNavigationItem
    }

    func setupBottomNavigationContainer() {
        if UIApplication.shared.windows.first?.subviews.contains(bottomNavigationContainer) == true {
            bringBottomNavigationBarToFront()
        } else {
            UIApplication.shared.windows.first?.addSubview(bottomNavigationContainer)
        }
    }

    func setupAudioPlayerBar() {
        if audioPlayerBar.superview != audioPlayerContainer {
            audioPlayerContainer.fill(subview: audioPlayerBar)
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(didStartAudio(_:)), name: .didStartAudio, object: nil)
            notificationCenter.addObserver(self, selector: #selector(didStopAudio(_:)), name: .didStopAudio, object: nil)
            notificationCenter.addObserver(self, selector: #selector(playPauseAudio(_:)), name: .playPauseAudio, object: nil)
            notificationCenter.addObserver(self, selector: #selector(stopAudio(_:)), name: .stopAudio, object: nil)
            notificationCenter.addObserver(self, selector: #selector(showAudioFullScreen(_:)), name: .showAudioFullScreen, object: nil)
            notificationCenter.addObserver(self, selector: #selector(hideAudioFullScreen(_:)), name: .hideAudioFullScreen, object: nil)
        }
    }
}

// MARK: - bottom navigation bar
extension BaseRootViewController {
    @objc func handleBottomNavigationBar(_ notification: Notification) {
        guard let navigationItem = notification.object as? BottomNavigationItem else {
            return
        }
        lastestBottomNavigationItem = navigationItem
        handleNavigationItems(leftItems: navigationItem.leftBarButtonItems,
                              rightItems: navigationItem.rightBarButtonItems,
                              backgroundColor: navigationItem.backgroundColor)
        // check last navigation items.
        checkBottomNavigationItemAfterPeriod(1.5, for: notification)
    }

    func bringBottomNavigationBarToFront(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.05, animations: {
            self.bottomNavigationContainer.alpha = 1
            self.bottomNavigationContainer.layer.zPosition = 1
        }, completion: { (_) in
            self.bottomNavigationContainer.alpha = 1
            self.bottomNavigationContainer.superview?.bringSubview(toFront: self.bottomNavigationContainer)
        })
    }

    func handleNavigationItems(leftItems: [UIBarButtonItem]?, rightItems: [UIBarButtonItem]?, backgroundColor: UIColor) {
        let navigationItem = UINavigationItem()
        let transparentView = UIView()
        transparentView.backgroundColor = .clear
        navigationItem.backBarButtonItem = UIBarButtonItem(customView: transparentView)
        bottomNavigationBar.setItems([navigationItem], animated: false)
        navigationItem.setLeftBarButtonItems(leftItems, animated: false)
        navigationItem.setRightBarButtonItems(rightItems, animated: false)
        bringBottomNavigationBarToFront()
        audioPlayerBar.refreshColorMode(isLight: backgroundColor.isLightColor())
    }

    private func checkBottomNavigationItemAfterPeriod(_ seconds: TimeInterval, for notification: Notification) {
        guard let navigationItem = notification.object as? BottomNavigationItem else {
            return
        }
        bottomNavigationUpdateTimer?.invalidate()
        bottomNavigationUpdateTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [weak self] (_) in
            var needToUpdate = false
            let currentNavigationItem = self?.navigationController?.navigationBar.items?.last
            if navigationItem.leftBarButtonItems.count != currentNavigationItem?.leftBarButtonItems?.count ?? 0 ||
                navigationItem.rightBarButtonItems.count != currentNavigationItem?.rightBarButtonItems?.count ?? 0 {
                    needToUpdate = true
            }

            for (index, item) in navigationItem.leftBarButtonItems.enumerated() {
                guard needToUpdate == false, let currentItem = currentNavigationItem?.leftBarButtonItems?[index] else {
                    needToUpdate = true
                    break
                }
                if (item.action != currentItem.action) || (item.customView != currentItem.customView) {
                    needToUpdate = true
                    break
                }
            }

            for (index, item) in navigationItem.rightBarButtonItems.enumerated() {
                guard needToUpdate == false, let currentItem = currentNavigationItem?.rightBarButtonItems?[index] else {
                    needToUpdate = true
                    break
                }
                if (item.action != currentItem.action) || (item.customView != currentItem.customView) {
                    needToUpdate = true
                    break
                }
            }

            if needToUpdate {
                self?.handleBottomNavigationBar(notification)
            }
        })
    }
}

// MARK: - Audio player
extension BaseRootViewController {
    @objc func playPauseAudio(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel,
        let url = mediaModel.url else {
            return
        }
        if url.isFileURL == false, // if it's not local file
            QOTReachability().isReachable == false { // and there is no internet
            self.showNoInternetConnectionAlert()
            return
        }
        audioPlayerBar.playPause(mediaModel)
    }

    @objc func stopAudio(_ notification: Notification) {
        audioPlayerBar.cancel()
    }

    @objc func didStartAudio(_ notification: Notification) {
        // update play button
        UIView.animate(withDuration: 0.25, animations: {
            self.audioPlayerContainer.alpha = 1
            self.bottomNavigationBar.alpha = 0
        }, completion: { [weak self] (finished) in
            self?.audioPlayerContainer.isUserInteractionEnabled = true
        })

        bringBottomNavigationBarToFront()
    }

    @objc func didStopAudio(_ notification: Notification) {
        self.audioPlayerContainer.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.audioPlayerContainer.alpha = 0
            self?.bottomNavigationBar.alpha = 1
        }, completion: { (finished) in

        })
        let currentItem = bottomNavigationBar.items?.last
        handleNavigationItems(leftItems: currentItem?.leftBarButtonItems,
                              rightItems: currentItem?.rightBarButtonItems,
                              backgroundColor: lastestBottomNavigationItem.backgroundColor)
    }

    @objc func showAudioFullScreen(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel,
            let vc = R.storyboard.audioFullScreenViewController().instantiateInitialViewController(),
            let fullScreenVC = vc as? AudioFullScreenViewController else {
                return
        }
        fullScreenVC.set(colorMode: lastestBottomNavigationItem.backgroundColor.isLightColor() ? .darkNot : .dark )
        fullScreenVC.configureMedia(mediaModel, isPlaying: audioPlayerBar.isPlaying)
        self.present(fullScreenVC, animated: true)
        audioPlayerBar.setBarMode(.progress)
    }

    @objc func hideAudioFullScreen(_ notification: Notification) {
        audioPlayerBar.setBarMode(.playPause)
        NotificationCenter.default.post(name: .stopAudio, object: nil)
    }

    @objc override public func QOTVisibleViewController() -> UIViewController? {
        if let naviVC = presentedViewController as? UINavigationController {
            return naviVC.QOTVisibleViewController()
        } else if let child = childViewControllers.last {
            return child.QOTVisibleViewController()
        }

        return self
    }
}
