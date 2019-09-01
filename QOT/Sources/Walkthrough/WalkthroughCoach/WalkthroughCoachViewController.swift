//
//  WalkthroughCoachViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughCoachViewController: UIViewController, ScreenZLevelBottom {

    // MARK: - Properties
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var coach: WalkthroughAnimatedCoach!

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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coach.stopAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coach.startAnimating()
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
