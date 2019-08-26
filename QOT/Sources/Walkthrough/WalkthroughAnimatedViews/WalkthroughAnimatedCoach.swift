//
//  WalkthroughAnimatedCoach.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class WalkthroughAnimatedCoach: UIView {

    // Properties
    private let coachQ = UIImageView()
    private let circle1 = UIView()
    private let circle2 = UIView()
    private let circle3 = UIView()
    private var views = [UIView]()

    private let borderWidth: CGFloat = 2
    private let color: UIColor = .sand

    private var timer: Timer?
    private let fadeIn: Double = 0.3
    private let delay: Double = 0.5
    private let fadeOut: Double = 0.1
    private let appearDelay: Double = 0.05

    lazy var totalDuration: Double = {
        return fadeIn + Double(views.count) * delay
    }()

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        coachQ.image = R.image.walkthrough_q()
        coachQ.contentMode = .center
        coachQ.layer.borderWidth = borderWidth
        coachQ.layer.borderColor = color.withAlphaComponent(0.7).cgColor
        views.append(coachQ)

        circle1.layer.borderWidth = borderWidth
        circle1.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        views.append(circle1)

        circle2.layer.borderWidth = borderWidth
        circle2.layer.borderColor = color.withAlphaComponent(0.2).cgColor
        views.append(circle2)

        circle3.layer.borderWidth = borderWidth
        circle3.layer.borderColor = color.withAlphaComponent(0.1).cgColor
        views.append(circle3)

        views.forEach { addSubview($0) }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let dimension = min(bounds.size.height, bounds.size.width)
        let min = 0.41 * dimension
        // Calculate the radius step increase for each circle
        let step = (dimension - min) / CGFloat(views.count > 2 ? views.count - 1 : 1)
        let center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)

        for (index, view) in views.enumerated() {
            let height = min + CGFloat(index) * step
            view.layer.cornerRadius = height * 0.5
            let size = CGSize(width: height, height: height)
            view.frame = CGRect(center: center, size: size)
        }
    }
}

// MARK: - Public methods

extension WalkthroughAnimatedCoach {

    func startAnimating() {
        stopAnimating()

        let interval: Double = totalDuration
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(animate),
                                     userInfo: nil,
                                     repeats: true)
        timer?.fire()
    }

    func stopAnimating() {
        timer?.invalidate()
        timer = nil
    }
}

private extension WalkthroughAnimatedCoach {
    @objc func animate() {
        UIView.animate(withDuration: fadeOut, delay: delay, options: .curveEaseIn, animations: {
            self.views.forEach { $0.alpha = 0 }
        })

        for (index, view) in views.enumerated() {
            let tempDelay = fadeOut + appearDelay + Double(index) * delay
            UIView.animate(withDuration: fadeIn, delay: tempDelay, options: .curveEaseOut, animations: {
                view.alpha = 1
            })
        }
    }
}
