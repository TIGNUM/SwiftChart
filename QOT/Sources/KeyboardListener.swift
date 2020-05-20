//
//  KeyboardListener.swift
//  QOT
//
//  Created by Sam Wyndham on 07/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class KeyboardListener {

    struct KeyboardInfo {

        let startFrame: CGRect
        let endFrame: CGRect
        let animationCurve: UIView.AnimationCurve?
        let animationDuration: TimeInterval?
    }

    enum State {

        case idle(height: CGFloat)
        case willChange(startHeight: CGFloat, endHeight: CGFloat, duration: TimeInterval, curve: UIView.AnimationCurve)

        var height: CGFloat {
            switch self {
            case .idle(let height):
                return height
            case .willChange(_, let endHeight, _, _):
                return endHeight
            }
        }
    }

    typealias Handler = (_ state: State) -> Void

    private var changeHandler: Handler?
    private(set) var state: State = .idle(height: 0) {
        didSet { changeHandler?(state) }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let info = notification.keyboardInfo,
            let duration = info.animationDuration,
            let curve = info.animationCurve else { return }

        let start = visibleHeight(keyboardFrame: info.startFrame)
        let end = visibleHeight(keyboardFrame: info.endFrame)
        state = .willChange(startHeight: start, endHeight: end, duration: duration, curve: curve)
    }

    @objc func keyboardDidHide(notification: NSNotification) {
        guard let info = notification.keyboardInfo else { return }

        state = .idle(height: visibleHeight(keyboardFrame: info.endFrame))
    }

    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        guard let info = notification.keyboardInfo,
            let duration = info.animationDuration,
            let curve = info.animationCurve else { return }

        let start = visibleHeight(keyboardFrame: info.startFrame)
        let end = visibleHeight(keyboardFrame: info.endFrame)
        state = .willChange(startHeight: start, endHeight: end, duration: duration, curve: curve)
    }

    @objc func keyboardDidChangeFrame(notification: NSNotification) {
        guard let info = notification.keyboardInfo else { return }

        state = .idle(height: visibleHeight(keyboardFrame: info.endFrame))
    }

    // FIXME: This only works when in portrait.
    private func visibleHeight(keyboardFrame: CGRect) -> CGFloat {
        let screenBounds = UIScreen.main.bounds
        return max(screenBounds.height - keyboardFrame.origin.y, 0)
    }
}

private extension NSNotification {

    var keyboardInfo: KeyboardListener.KeyboardInfo? {
        guard let userInfo = userInfo,
            let startFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return nil }

        let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue

        return KeyboardListener.KeyboardInfo(startFrame: startFrame,
                                              endFrame: endFrame,
                                              animationCurve: curve.flatMap { UIView.AnimationCurve(rawValue: $0) },
                                              animationDuration: duration.map { TimeInterval($0) })
    }
}
