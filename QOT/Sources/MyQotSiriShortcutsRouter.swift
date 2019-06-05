//
//  MyQotSiriShortcutsRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import IntentsUI

final class MyQotSiriShortcutsRouter {

    private let viewController: MyQotSiriShortcutsViewController

    init(viewController: MyQotSiriShortcutsViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyQotSiriShortcutsRouterInterface

extension MyQotSiriShortcutsRouter: MyQotSiriShortcutsRouterInterface {
    func handleTap(for shortcut: SiriShortcutsModel.Shortcut?) {
        if #available(iOS 12.0, *) {
            switch shortcut?.type {
            case .toBeVision?:
                let intent = ReadVisionIntent()
                intent.suggestedInvocationPhrase = shortcut?.suggestion
                presentShortcutViewController(with: intent)
            case .morningInterview?:
                let intent = DailyPrepIntent()
                intent.suggestedInvocationPhrase = shortcut?.suggestion
                presentShortcutViewController(with: intent)
            case .upcomingEventPrep?:
                let intent = UpcomingEventIntent()
                intent.suggestedInvocationPhrase = shortcut?.suggestion
                presentShortcutViewController(with: intent)
            case .whatsHot?:
                let intent = WhatsHotIntent()
                intent.suggestedInvocationPhrase = shortcut?.suggestion
                presentShortcutViewController(with: intent)
            default: return
            }
        }
    }
}

// MARK: - Private

private extension MyQotSiriShortcutsRouter {

    func presentShortcutViewController(with intent: INIntent) {
        if #available(iOS 12.0, *) {
            if let shortcut = INShortcut(intent: intent) {
                let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut)
                vc.delegate = viewController
                viewController.present(vc, animated: true, completion: nil)
            }
        }
    }
}
