//
//  WalkthroughSwipeViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughSwipeViewController: BaseViewController, ScreenZLevelOverlay {

    // MARK: - Properties
    @IBOutlet private weak var leftArrows: WalkthroughAnimatedArrows!
    @IBOutlet private weak var rightArrows: WalkthroughAnimatedArrows!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!

    var interactor: WalkthroughSwipeInteractorInterface?

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

}

// MARK: - Private

private extension WalkthroughSwipeViewController {
}

// MARK: - Actions

private extension WalkthroughSwipeViewController {

}

// MARK: - WalkthroughSearchViewControllerInterface

extension WalkthroughSwipeViewController: WalkthroughSwipeViewControllerInterface {

    func setupView() {
        rightArrows.presentStationary()
        rightArrows.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
        rightArrows.alpha = 0.25

        leftArrows.presentStationary()
        leftArrows.alpha = 0.25

        ThemeText.walkthroughMessage.apply(interactor?.text, to: textLabel)
    }
}
