//
//  SiriShortcutsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import IntentsUI

final class SiriShortcutsRouter {

    private let siriShortcutsViewController: SiriShortcutsViewController

    init(siriShortcutsViewController: SiriShortcutsViewController, services: Services) {
        self.siriShortcutsViewController = siriShortcutsViewController
    }
}

// MARK: - SiriShortcutssRouterInterface

extension SiriShortcutsRouter: SiriShortcutsRouterInterface {

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

// MARK: - INUIAddVoiceShortcutViewControllerDelegate

extension SiriShortcutsViewController: INUIAddVoiceShortcutViewControllerDelegate {

    @available(iOS 12.0, *)
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                        didFinishWith voiceShortcut: INVoiceShortcut?,
                                        error: Error?) {
        dismiss(animated: true, completion: nil)
    }

    @available(iOS 12.0, *)
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private

private extension SiriShortcutsRouter {

    func presentShortcutViewController(with intent: INIntent) {
        if #available(iOS 12.0, *) {
            if let shortcut = INShortcut(intent: intent) {
                let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut)
                vc.delegate = siriShortcutsViewController
                siriShortcutsViewController.present(vc, animated: true, completion: nil)
            }
        }
    }
}
