//
//  ResultsFeedbackViewController.swift
//  QOT
//
//  Created by karmic on 21.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol ResultsFeedbackDismissDelegate: class {
    func dismissResultPage()
}

final class ResultsFeedbackViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var textLabel: UILabel!
    weak var delegate: ResultsFeedbackDismissDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = nil
    }

    // MARK: - Configuration
    func configure(text: String) {
        ThemeText.resultClosingText.apply(text, to: textLabel)
        ThemeView.chatbot.apply(self.view)
        textLabel.text = text
    }

    // MARK: - Actions
    @objc func didTapDone() {
        if delegate != nil {
            delegate?.dismissResultPage()
        } else {
            AppDelegate.current.launchHandler.dismissChatBotFlow()
        }
    }
}

// MARK: - BottomNavigation
extension ResultsFeedbackViewController {
    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return [doneButtonItem(#selector(didTapDone))]
    }
}
