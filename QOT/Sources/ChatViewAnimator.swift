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
