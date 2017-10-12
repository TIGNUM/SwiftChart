//
//  ChatViewAnimator.swift
//  QOT
//
//  Created by Sam Wyndham on 28.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ChatViewAnimator {

    typealias CancelHandler = () -> Void
    typealias AnimationHandler = (_ view: UICollectionReusableView, _ attributes: ChatViewLayoutAttibutes) -> CancelHandler

    private var animationHandler: AnimationHandler?
    private var cancelHandler: CancelHandler?

    init(animationHandler: @escaping AnimationHandler) {
        self.animationHandler = animationHandler
    }

    func animate(view: UICollectionReusableView, using attributes: ChatViewLayoutAttibutes) {
        cancelHandler = animationHandler?(view, attributes)
        animationHandler = nil
    }

    func cancel() {
        animationHandler = nil
        cancelHandler?()
        cancelHandler = nil
    }
}

extension ChatViewAnimator {

    static func messageAnimator() -> ChatViewAnimator {
        return ChatViewAnimator { (view, attrs) -> CancelHandler in
            guard let view = view as? ChatViewCell, let date = attrs.insertedAt, date.timeIntervalToNow < 0.5 else {
                return {}
            }

            let startTyping: CFTimeInterval = 0
            let stopTyping: CFTimeInterval = 1
            let fadeInLabel: CFTimeInterval = 1.1
            let finish: CFTimeInterval = 1.2

            func typingBackgroundViewAnimations() -> [CAKeyframeAnimation] {
                let startBounds = CGRect(x: 0, y: 0, width: 60, height: 40)
                let endBounds = CGRect(origin: .zero, size: attrs.frame.size)
                let startPosition = CGPoint(x: startBounds.midX, y: startBounds.midY)
                let endPosition = CGPoint(x: endBounds.midX, y: endBounds.midY)
                return [
                    CAKeyframeAnimation(keyPath: "bounds",
                                        valuesAtTimes: [startTyping: startBounds,
                                                        stopTyping: startBounds,
                                                        finish: endBounds]),
                    CAKeyframeAnimation(keyPath: "position",
                                        valuesAtTimes: [startTyping: startPosition,
                                                        stopTyping: startPosition,
                                                        finish: endPosition]),
                    CAKeyframeAnimation(keyPath: "opacity", valuesAtTimes: [startTyping: 1, finish: 1])
                ]
            }

            func labelViewAnimations() -> [CAKeyframeAnimation] {
                return [CAKeyframeAnimation(keyPath: "opacity",
                                            valuesAtTimes: [startTyping: 0, fadeInLabel: 0, finish: 1])]
            }

            func dashedViewAnimations() -> [CAKeyframeAnimation] {
                return [CAKeyframeAnimation(keyPath: "opacity", valuesAtTimes: [startTyping: 0, finish: 0])]
            }

            let animations: [CALayer: [CAPropertyAnimation]] = [
                view.typingBackgroundView.layer: typingBackgroundViewAnimations(),
                view.label.layer: labelViewAnimations(),
                view.dashedLineView.layer: dashedViewAnimations()
            ]

            for (layer, anims) in animations {
                for animation in anims {
                    layer.add(animation, forKey: animation.keyPath)
                }
            }

            return {
                for (layer, anims) in animations {
                    for animation in anims {
                        if let keyPath = animation.keyPath {
                            layer.removeAnimation(forKey: keyPath)
                        }
                    }
                }
            }
        }
    }

    static func slideInAnimator(xOffset: CGFloat, duration: CFTimeInterval, delay: CFTimeInterval) -> ChatViewAnimator {
        return ChatViewAnimator { (view, attrs) -> CancelHandler in
            guard let date = attrs.insertedAt, date.timeIntervalToNow < 0.5 else {
                return {}
            }

            let keyPath = "transform.translation.x"
            let start: CFTimeInterval = delay
            let finish: CFTimeInterval = delay + duration
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x",
                                                valuesAtTimes: [start: xOffset, finish: 0])
            view.layer.add(animation, forKey: keyPath)
            return {
                view.layer.removeAnimation(forKey: keyPath)
            }
        }
    }

    static func fadeInAnimator(duration: CFTimeInterval, delay: CFTimeInterval) -> ChatViewAnimator {
        return ChatViewAnimator { (view, attrs) -> CancelHandler in
            guard let date = attrs.insertedAt, date.timeIntervalToNow < 0.5 else {
                return {}
            }

            let keyPath = "opacity"
            let start: CFTimeInterval = delay
            let finish: CFTimeInterval = delay + duration
            let animation = CAKeyframeAnimation(keyPath: "opacity",
                                                valuesAtTimes: [start: 0, finish: 1])
            view.layer.add(animation, forKey: keyPath)
            return {
                view.layer.removeAnimation(forKey: keyPath)
            }
        }
    }
}

private extension CAKeyframeAnimation {

    convenience init(keyPath: String, valuesAtTimes: DictionaryLiteral<CFTimeInterval, Any>) {
        self.init(keyPath: keyPath)

        var times: [CFTimeInterval] = []
        var values: [Any] = []
        for (time, value) in valuesAtTimes {
            times.append(time)
            values.append(value)
        }
        if let duration = times.max() {
            self.duration = duration
            self.keyTimes = times.map { NSNumber(value: $0 / duration) }
            self.values = values
            self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
    }
}
