//
//  WalkthroughAnimatedArrows.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class WalkthroughAnimatedArrows: UIView {

    // Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var contentLeftConstraint: NSLayoutConstraint!
    @IBOutlet private var arrows: [UIView]!

    private var timer: Timer?
    private let timerTolerance: Double = 0.1
    private let fadeIn: Double = 0.2
    private let visible: Double = 0.5
    private let fadeOut: Double = 0.35
    private let overlap: Double = 0.2

    lazy var totalDuration: Double = {
        return fadeIn + Double(arrows.count) * visible + fadeOut
    }()

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
        containerView.prepareForInterfaceBuilder()
        arrows.forEach { $0.alpha = 1 }
    }

    func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        fill(subview: containerView)

        arrows.forEach { $0.alpha = 0 }
    }
}

// MARK: - Public methods

extension WalkthroughAnimatedArrows {

    func startAnimating(repeatingInterval: Double? = nil) {
        stopAnimating()

        let minInterval = (totalDuration + 1.5 * timerTolerance)
        let interval: Double
        if let period = repeatingInterval, period > minInterval {
            interval = period
        } else {
            interval = minInterval
        }
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(animate),
                                     userInfo: nil,
                                     repeats: true)
        timer?.tolerance = timerTolerance
        timer?.fire()
    }

    func stopAnimating() {
        timer?.invalidate()
        timer = nil
    }
}

private extension WalkthroughAnimatedArrows {
    @objc func animate() {
        // Slide
        contentLeftConstraint.constant = self.frame.size.width * 0.25
        UIView.animate(withDuration: totalDuration, delay: 0, options: .curveLinear, animations: {
            self.layoutIfNeeded()
        }, completion: { (_) in
            self.contentLeftConstraint.constant = 0
            self.layoutIfNeeded()
        })

        // Arrows
        for (index, view) in arrows.enumerated() {
            let tempDelay = Double(index) * (fadeIn + visible - overlap)
            UIView.animate(withDuration: fadeIn, delay: tempDelay, options: .curveEaseIn, animations: {
                view.alpha = 1
            }, completion: { (_) in
                UIView.animate(withDuration: self.fadeOut, delay: self.visible, options: .curveEaseIn, animations: {
                    view.alpha = 0
                })
            })
        }
    }
}
