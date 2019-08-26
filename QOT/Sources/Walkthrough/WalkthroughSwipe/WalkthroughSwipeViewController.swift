//
//  WalkthroughSwipeViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughSwipeViewController: UIViewController, ScreenZLevelBottom {

    // MARK: - Properties
    @IBOutlet private weak var leftArrows: WalkthroughAnimatedArrows!
    @IBOutlet private weak var rightArrows: WalkthroughAnimatedArrows!
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        leftArrows.stopAnimating()
        rightArrows.stopAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let interval = 2 * leftArrows.totalDuration
        leftArrows.startAnimating(repeatingInterval: interval)
        DispatchQueue.main.asyncAfter(deadline: .now() + leftArrows.totalDuration) {
            self.rightArrows.startAnimating(repeatingInterval: interval)
        }
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
        rightArrows.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)

        textView.text = interactor?.text

    }
}
