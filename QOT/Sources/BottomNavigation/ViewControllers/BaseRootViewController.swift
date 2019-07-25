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
    @IBOutlet weak var naviBackground: UIImageView!
    @IBOutlet weak var bottomNavigationBar: UINavigationBar!
    @IBOutlet weak var audioPlayerContainer: UIView!

    internal var audioPlayerBar = AudioPlayerBar.instantiateFromNib()

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
        super.viewDidAppear(animated)
        refreshBottomNavigationItems()
    }

    override func viewDidLayoutSubviews() {
        let frame = bottomNavigationPlaceholder.frame
        bottomNavigationContainer.frame = frame
    }
}

// MARK: - Setup
extension BaseRootViewController {
    func setContent(viewController: UIViewController) {
        addChildViewController(viewController)
        view.fill(subview: viewController.view)
    }
}
