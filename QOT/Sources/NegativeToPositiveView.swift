//
//  NegativeToPositiveTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class NegativeToPositiveView: UIView, UIGestureRecognizerDelegate {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var lowPerformanceView: UIView!
    @IBOutlet private weak var lowTitleLabel: UILabel!
    @IBOutlet private weak var lowFirstItemLabel: UILabel!
    @IBOutlet private weak var lowSecondItemLabel: UILabel!
    @IBOutlet private weak var lowThirdItemLabel: UILabel!
    @IBOutlet private weak var highTitleLabel: UILabel!
    @IBOutlet private weak var highFirstItemLabel: UILabel!
    @IBOutlet private weak var highSecondItemLabel: UILabel!
    @IBOutlet private weak var highThirdItemLabel: UILabel!
    @IBOutlet private weak var highPerformanceView: UIView!
    @IBOutlet private weak var highPerformanceContainerView: UIView!
    @IBOutlet private weak var highPerformanceConstraint: NSLayoutConstraint!
    @IBOutlet private var horizontalConstraints: [NSLayoutConstraint]!
    @IBOutlet private var verticalConstraints: [NSLayoutConstraint]!
    @IBOutlet private var barViews: [UIView]!

    private var darkMode: Bool = true
    private var themeMode: ThemeColorMode = .dark
    private var skeletonManager = SkeletonManager()

    private var initialOffset: CGFloat = 0
    private let singleOffset: CGFloat = 25

    lazy var leftOffset: CGFloat = { return .zero }()
    lazy var middleOffset: CGFloat = { return self.bounds.width * 0.33 - self.singleOffset }()
    lazy var rightOffset: CGFloat = { return self.bounds.width - 2 * self.singleOffset }()

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.clipTo(self.middleOffset, duration: 0.5)
        }
    }

    func addTo(superview: UIView, showSkeleton: Bool = false, darkMode: Bool = true) {
        superview.fill(subview: self)
        self.darkMode = darkMode
        if showSkeleton {
            skeletonManager.addTitle(titleLabel)
            skeletonManager.addOtherView(lowPerformanceView)
            skeletonManager.addOtherView(lowTitleLabel)
            skeletonManager.addOtherView(lowFirstItemLabel)
            skeletonManager.addOtherView(lowSecondItemLabel)
            skeletonManager.addOtherView(lowThirdItemLabel)
            skeletonManager.addOtherView(highTitleLabel)
            skeletonManager.addOtherView(highFirstItemLabel)
            skeletonManager.addOtherView(highSecondItemLabel)
            skeletonManager.addOtherView(highThirdItemLabel)
            skeletonManager.addOtherView(highPerformanceView)
            skeletonManager.addOtherView(highPerformanceContainerView)
        }
     }

    override func layoutSubviews() {
        super.layoutSubviews()
        if initialOffset == .zero {
            initialOffset = self.bounds.width * 0.5 - self.singleOffset
            highPerformanceConstraint.constant = initialOffset
        }
    }
}

// MARK: - Configuration
extension NegativeToPositiveView {
    func configure(title: String, lowTitle: String, lowItems: [String], highTitle: String, highItems: [String]) {
        skeletonManager.hide()
        if self.darkMode { themeMode = .dark
        } else { themeMode = .light }

        barViews.forEach { (view) in
            ThemeView.barViews(themeMode).apply(view)
        }

        ThemeView.tbvLowPerformance(themeMode).apply(lowPerformanceView)
        ThemeView.tbvHighPerformance(themeMode).apply(highPerformanceView)
        ThemeText.resultTitle.apply(title, to: titleLabel)

        ThemeText.tbvQuestionLight.apply(lowTitle, to: lowTitleLabel)
        ThemeText.tbvQuestionLight.apply(lowItems[0, default: "lowItem_\(0) not set"], to: lowFirstItemLabel)
        ThemeText.tbvQuestionLight.apply(lowItems[1, default: "lowItem_\(1) not set"], to: lowSecondItemLabel)
        ThemeText.tbvQuestionLight.apply(lowItems[2, default: "lowItem_\(2) not set"], to: lowThirdItemLabel)
        ThemeText.resultTitleTheme(themeMode).apply(highTitle, to: highTitleLabel)
        ThemeText.resultHeaderTheme2(themeMode).apply(highItems[0, default: "highItem_\(0) not set"], to: highFirstItemLabel)
        ThemeText.resultHeaderTheme2(themeMode).apply(highItems[1, default: "highItem_\(1) not set"], to: highSecondItemLabel)
        ThemeText.resultHeaderTheme2(themeMode).apply(highItems[2, default: "highItem_\(2) not set"], to: highThirdItemLabel)
    }
}

// MARK: - Private
private extension NegativeToPositiveView {
    func setupView() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(syncHighPerformanceView(_:)))
        gestureRecognizer.delegate = self
        highPerformanceContainerView.addGestureRecognizer(gestureRecognizer)
        highPerformanceView.layer.shadowOpacity = 0.2
        highPerformanceView.layer.shadowRadius = 5
        highPerformanceView.layer.shadowOffset = CGSize(width: -10, height: 0)
    }

    func randomSet(max: Int) -> (index1: Int, index2: Int, index3: Int) {
        guard max >= 3 else {
            return (0, 0, 0)
        }

        let index1 = Int.random(in: 0..<max)
        var index2: Int = -1
        while index2 < .zero || index2 == index1 {
            index2 = Int.random(in: 0..<max)
        }
        var index3: Int = -1
        while index3 < .zero || index3 == index1 || index3 == index2 {
            index3 = Int.random(in: 0..<max)
        }
        return(index1, index2, index3)
    }

    func endSlide(for position: CGFloat) {
        if position < (self.bounds.size.width * 0.25) {
            clipTo(leftOffset)
        } else if position > (self.bounds.size.width * 0.65) {
            clipTo(rightOffset)
        } else {
            clipTo(middleOffset)
        }
    }

    func clipTo(_ offset: CGFloat, duration: Double = Animation.duration_04) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.highPerformanceConstraint.constant = offset
            self?.layoutIfNeeded()
        })
    }
}

// MARK: - GestureRecognizer
private extension NegativeToPositiveView {
    @objc func syncHighPerformanceView(_ gestureRecognizer: UIPanGestureRecognizer) {
        // Remember starting position
        if gestureRecognizer.state == .began {
            initialOffset = highPerformanceConstraint.constant
        }

        // Get offset
        let point = gestureRecognizer.translation(in: self)
        let finalPosition = self.initialOffset + point.x

        // Handle end (take velocity into account to determine the end position)
        if gestureRecognizer.state == .ended {
            endSlide(for: finalPosition + gestureRecognizer.velocity(in: highPerformanceContainerView).x * 0.3)
            return
        }

        // Animate slide
        UIView.animate(withDuration: Animation.duration_02) { [weak self] in
            self?.highPerformanceConstraint.constant = finalPosition
            self?.layoutIfNeeded()
        }
    }
}

// Gesture recognizer delegate
extension NegativeToPositiveView {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let velocity = pan.velocity(in: highPerformanceContainerView)
        return abs(velocity.x) > abs(velocity.y)
    }

    func calculateHeight(for width: CGFloat) -> CGFloat {
        // setting minimum to 1
        var height: CGFloat = 1
        var verticalConstraintsSum: CGFloat = 0
        var horizontalConstraintsSum: CGFloat = 0
        for constraint in verticalConstraints {
            verticalConstraintsSum += constraint.constant
        }
        for constraint in horizontalConstraints {
            horizontalConstraintsSum += constraint.constant
        }
        let titleLabelSize = titleLabel.sizeThatFits(CGSize(width: width - horizontalConstraintsSum,
                                                            height: .greatestFiniteMagnitude))
        height += titleLabelSize.height + verticalConstraintsSum
        return height
    }
}

extension NegativeToPositiveView {
    static func instantiateMindsetView(superview: UIView, showSkeleton: Bool = false, darkMode: Bool = true) -> NegativeToPositiveView {
        let negativeToPositiveView = R.nib.negativeToPositiveView.firstView(owner: superview)
        negativeToPositiveView?.addTo(superview: superview, showSkeleton: showSkeleton, darkMode: darkMode)
        return negativeToPositiveView ?? NegativeToPositiveView.init(frame: .zero)
    }
}
