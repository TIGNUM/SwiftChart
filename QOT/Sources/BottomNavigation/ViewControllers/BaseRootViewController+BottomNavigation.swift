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
        let lastItem = bottomNavigationBar.items?.last
        let lastBottomItem = BottomNavigationItem(leftBarButtonItems: lastItem?.leftBarButtonItems ?? [],
                                                  rightBarButtonItems: lastItem?.rightBarButtonItems ?? [],
                                                  backgroundColor: .clear)
        return lastBottomItem
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
        handleNavigationItems(leftItems: navigationItem.leftBarButtonItems,
                              rightItems: navigationItem.rightBarButtonItems)
    }

    func bringBottomNavigationBarToFront(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1) {
            self.bottomNavigationContainer.alpha = 1
            self.bottomNavigationContainer.layer.zPosition = 1
            self.bottomNavigationContainer.superview?.bringSubview(toFront: self.bottomNavigationContainer)
        }
    }

    func handleNavigationItems(leftItems: [UIBarButtonItem]?, rightItems: [UIBarButtonItem]?) {
        let navigationItem = UINavigationItem()
        let transparentView = UIView()
        transparentView.backgroundColor = .clear
        navigationItem.backBarButtonItem = UIBarButtonItem(customView: transparentView)
        bottomNavigationBar.setItems([navigationItem], animated: false)
        navigationItem.setLeftBarButtonItems(leftItems, animated: false)
        navigationItem.setRightBarButtonItems(rightItems, animated: false)
        bringBottomNavigationBarToFront()
        audioPlayerBar.setColorMode(colorMode.isLightMode ? ColorMode.darkNot : ColorMode.dark)
    }
}

// MARK: - Audio player
extension BaseRootViewController {
    @objc func playPauseAudio(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel else {
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
        }, completion: { (finished) in
            self.audioPlayerContainer.isUserInteractionEnabled = true
        })

        bringBottomNavigationBarToFront()
    }

    @objc func didStopAudio(_ notification: Notification) {
        self.audioPlayerContainer.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.audioPlayerContainer.alpha = 0
            self.bottomNavigationBar.alpha = 1
        }, completion: { (finished) in

        })
        let currentItem = bottomNavigationBar.items?.last
        handleNavigationItems(leftItems: currentItem?.leftBarButtonItems, rightItems: currentItem?.rightBarButtonItems)
    }

    @objc func showAudioFullScreen(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel,
            let vc = R.storyboard.audioFullScreenViewController().instantiateInitialViewController(),
            let fullScreenVC = vc as? AudioFullScreenViewController else {
                return
        }

        fullScreenVC.configureMedia(mediaModel, isPlaying: audioPlayerBar.isPlaying)
        self.present(fullScreenVC, animated: true)
        audioPlayerBar.setBarMode(.progress)
    }

    @objc func hideAudioFullScreen(_ notification: Notification) {
        audioPlayerBar.setBarMode(.playPause)
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
