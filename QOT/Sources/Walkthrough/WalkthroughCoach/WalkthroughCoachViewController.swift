//
//  WalkthroughCoachViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughCoachViewController: UIViewController, ScreenZLevelOverlay {

    // MARK: - Properties
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!

    var interactor: WalkthroughCoachInteractorInterface?

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

private extension WalkthroughCoachViewController {
}

// MARK: - Actions

private extension WalkthroughCoachViewController {

}

// MARK: - WalkthroughSearchViewControllerInterface

extension WalkthroughCoachViewController: WalkthroughCoachViewControllerInterface {

    func setupView() {
        ThemeText.walkthroughMessage.apply(interactor?.text, to: textLabel)
    }
}
