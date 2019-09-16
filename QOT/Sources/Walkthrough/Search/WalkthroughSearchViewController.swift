//
//  WalkthroughSearchViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughSearchViewController: UIViewController, ScreenZLevelOverlay {

    // MARK: - Properties
    @IBOutlet private weak var arrows: WalkthroughAnimatedArrows!
    @IBOutlet private weak var textLabel: UILabel!

    var interactor: WalkthroughSearchInteractorInterface?

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        arrows.startAnimating()
    }
}

// MARK: - Private

private extension WalkthroughSearchViewController {
}

// MARK: - Actions

private extension WalkthroughSearchViewController {

}

// MARK: - WalkthroughSearchViewControllerInterface

extension WalkthroughSearchViewController: WalkthroughSearchViewControllerInterface {

    func setupView() {
        arrows.presentStationary()
        arrows.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 0.5)
        arrows.alpha = 0.25

        ThemeText.walkthroughMessage.apply(interactor?.text, to: textLabel)
    }
}
