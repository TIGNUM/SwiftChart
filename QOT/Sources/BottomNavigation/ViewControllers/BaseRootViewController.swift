//
//  ViewController.swift
//  LevelNavigationDemo
//
//  Created by Sanggeon Park on 19.06.19.
//  Copyright © 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit

protocol ScreenZLevelBottom: UIViewController {}
protocol ScreenZLevel1: ScreenZLevel {}
protocol ScreenZLevel2: ScreenZLevel {}
protocol ScreenZLevel3: ScreenZLevel {}
protocol ScreenZLevelCoach: ScreenZLevel3 {}
protocol ScreenZLevelOverlay: ScreenZLevel {}
protocol ScreenZLevelIgnore: ScreenZLevel {}
protocol ScreenZLevelChatBot: ScreenZLevel {}

final class BaseRootViewController: UIViewController, ScreenZLevel1 {

    @IBOutlet weak var bottomNavigationPlaceholder: UIView!
    @IBOutlet var bottomNavigationContainer: UIView!
    @IBOutlet weak var bottomNavigationBar: UINavigationBar!
    @IBOutlet weak var audioPlayerContainer: UIView!
    @IBOutlet weak var bottomNavigationBottomConstraint: NSLayoutConstraint!
    @IBOutlet var contentContainer: UIView!
    public var shouldMoveBottomBarWithKeyboard: Bool = false
    internal var audioPlayerBar = AudioPlayerBar.instantiateFromNib()
    private weak var contentView: UIView?
    internal var lastestBottomNavigationItem: BottomNavigationItem = BottomNavigationItem(leftBarButtonItems: [],
                                                                                       rightBarButtonItems: [],
                                                                                       backgroundColor: .black)

    deinit {
        bottomNavigationContainer.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        baseRootViewController = self
        ThemeView.level1.apply(view)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleBottomNavigationBar(_:)),
                                               name: .updateBottomNavigation,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userLogout(_:)),
                                               name: .userLogout,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userLogout(_:)),
                                               name: .automaticLogout,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
        setupBottomNavigationContainer()
        setupAudioPlayerBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBottomNavigationContainer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let frame = bottomNavigationPlaceholder.frame
        bottomNavigationContainer.frame = frame
    }
}

// MARK: - Session related Notification
extension BaseRootViewController {
    @objc func userLogout(_ notification: Notification) {
        resetContent()
    }
}

// MARK: - Setup
extension BaseRootViewController {
    func setContent(viewController: UIViewController) {
        contentView?.removeFromSuperview()
        childViewControllers.forEach({ $0.removeFromParentViewController() })
        addChildViewController(viewController)
        contentContainer.fill(subview: viewController.view)
        contentView = viewController.view
    }

    func resetContent() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: .didStartAudio, object: nil)
        notificationCenter.removeObserver(self, name: .didStopAudio, object: nil)
        notificationCenter.removeObserver(self, name: .playPauseAudio, object: nil)
        notificationCenter.removeObserver(self, name: .stopAudio, object: nil)
        notificationCenter.removeObserver(self, name: .showAudioFullScreen, object: nil)
        notificationCenter.removeObserver(self, name: .hideAudioFullScreen, object: nil)
        contentView?.removeFromSuperview()
        childViewControllers.forEach({ $0.removeFromParentViewController() })
        self.navigationController?.dismissAllPresentedViewControllers(self, false) {}
        navigationController?.popToRootViewController(animated: false)
    }
}

// MARK: - Bottom Navigation
extension BaseRootViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        guard self.navigationController?.presentedViewController == nil,
            let contentViewController = self.childViewControllers.first else {
                return nil
        }
        return contentViewController.bottomNavigationLeftBarItems()
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        guard self.navigationController?.presentedViewController == nil,
            let contentViewController = self.childViewControllers.first else {
                return nil
        }
        return contentViewController.bottomNavigationRightBarItems()
    }
}

//Handle keyboard notifications
extension BaseRootViewController {
    @objc func keyboardWillShow(notification: Notification) {
        if shouldMoveBottomBarWithKeyboard,
            let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.bottomNavigationBottomConstraint.constant = -keyboardSize.height
            }
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.bottomNavigationBottomConstraint.constant = 0
            }
            view.layoutIfNeeded()
        }
    }
}
