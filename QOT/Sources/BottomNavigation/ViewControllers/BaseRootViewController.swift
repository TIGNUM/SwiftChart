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

final class BaseRootViewController: UIViewController, ScreenZLevelBottom {

    @IBOutlet weak var bottomNavigationPlaceholder: UIView!

    @IBOutlet var bottomNavigationContainer: UIView!
    @IBOutlet weak var bottomNavigationBar: UINavigationBar!
    @IBOutlet weak var audioPlayerContainer: UIView!

    internal var audioPlayerBar = AudioPlayerBar.instantiateFromNib()
    private weak var contentView: UIView?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorMode.dark.statusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        baseRootViewController = self
        view.backgroundColor = .carbonDark
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
    }

    deinit {
        bottomNavigationContainer.removeFromSuperview()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBottomNavigationContainer()
        setupAudioPlayerBar()
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
        setupBottomNavigationContainer()
        setupAudioPlayerBar()
        contentView?.removeFromSuperview()
        childViewControllers.forEach({ $0.removeFromParentViewController() })
        addChildViewController(viewController)
        view.fill(subview: viewController.view)
        contentView = viewController.view
    }

    func resetContent() {
        contentView?.removeFromSuperview()
        childViewControllers.forEach({ $0.removeFromParentViewController() })
        if let root = self.navigationController?.presentedViewController {
            self.navigationController?.dismissAllPresentedViewControllers(root, false) {}
        }
        navigationController?.popToRootViewController(animated: false)
    }
}

// MARK: - Bottom Navigation
extension BaseRootViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        if let contentViewController = self.childViewControllers.first {
            return contentViewController.bottomNavigationLeftBarItems()
        }
        return nil
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if let contentViewController = self.childViewControllers.first {
            return contentViewController.bottomNavigationRightBarItems()
        }
        return super.bottomNavigationRightBarItems()
    }
}
