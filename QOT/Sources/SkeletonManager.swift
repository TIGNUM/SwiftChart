//
//  SkeletonManager.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class SkeletonManager {
    /**
     In order to use this manager to apply skeleton loading feature to different views all you have to do is call the addTitle, addSubtitle or addOtherView methods.
     This will automatically setup the skeleton according to the type of view and start animating it

     When the data has been loaded, in order to stop the skeleton hide() must be called

 */
    // MARK: Properties
    private var skeletonableTitles: [UIView] = []
    private var skeletonableSubtitles: [UIView] = []
    private var skeletonableOtherViews: [UIView] = []
    private var titleColor: UIColor = UIColor.skeletonTitleColor
    private var subtitleColor: UIColor = UIColor.skeletonSubtitleColor
    private var otherViewColor: UIColor = UIColor.skeletonOtherViewsColor
    private var shimmerAnimationDuration: CFTimeInterval = 1.5
    private var dissolveAnimationDuration: Double = 0.75

    private var originalButtonLayerBorderWidth = [String: CGFloat]()

    // MARK: Lifecycle

    init(titleColor: UIColor = .skeletonTitleColor,
         subtitleColor: UIColor = .skeletonTitleColor,
         otherViewColor: UIColor = .skeletonTitleColor,
         shimmerAnimationDuration: CFTimeInterval = 1.5,
         dissolveAnimationDuration: Double = 0.75) {
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.otherViewColor = otherViewColor
        self.shimmerAnimationDuration = shimmerAnimationDuration
        self.dissolveAnimationDuration = dissolveAnimationDuration
    }

    deinit {
        hide()
    }

    // MARK: Public
    func addTitle(_ view: UIView) {
        skeletonableTitles.append(view)
        addShimmerView(to: view, withBackgroundColor: titleColor, lighterShimmer: true)
    }

    func addSubtitle(_ view: UIView) {
        skeletonableSubtitles.append(view)
        addShimmerView(to: view, withBackgroundColor: subtitleColor, lighterShimmer: true)
    }

    func addOtherView(_ view: UIView) {
        skeletonableOtherViews.append(view)
        addShimmerView(to: view, withBackgroundColor: otherViewColor, lighterShimmer: true)
    }

    func hide() {
        for view in self.skeletonableTitles {
            self.removeShimmerView(from: view, withAnimationDuration: dissolveAnimationDuration)
        }
        for view in self.skeletonableSubtitles {
            self.removeShimmerView(from: view, withAnimationDuration: dissolveAnimationDuration)
        }

        for view in self.skeletonableOtherViews {
            self.removeShimmerView(from: view, withAnimationDuration: dissolveAnimationDuration)
        }
        self.skeletonableTitles.removeAll()
        self.skeletonableSubtitles.removeAll()
        self.skeletonableOtherViews.removeAll()
    }

    // MARK: Private
    private func addShimmerView(to view: UIView, withBackgroundColor: UIColor, lighterShimmer: Bool) {
        if view.isKind(of: UIButton.self) {
            guard let button = view as? UIButton else { return }
            storeLayerBorderWidth(from: button)
            button.titleLabel?.isHidden = true
            button.layer.borderWidth = 0
        }
        let shimmerView = ShimmerAnimatedView.init(frame: view.frame, color: withBackgroundColor, animationDuration: shimmerAnimationDuration, lighterShimmer: lighterShimmer)
        shimmerView.isUserInteractionEnabled = true
        UIView.transition(with: view, duration: dissolveAnimationDuration, options: [.transitionCrossDissolve], animations: {
            shimmerView.fillOverLayerBorder(for: shimmerView, superview: view)
            view.bringSubview(toFront: shimmerView)
        }, completion: nil)
    }

    private func removeShimmerView(from view: UIView, withAnimationDuration: Double) {
        for shimmerView in view.subviews where shimmerView as? ShimmerAnimatedView != nil {
            if let button = view as? UIButton {
                button.titleLabel?.isHidden = false
                restoreLayerBorderWidth(for: button)
            }
            UIView.transition(with: view, duration: withAnimationDuration, options: [.transitionCrossDissolve], animations: {
                shimmerView.removeFromSuperview()
            }, completion: nil)
        }
    }
}

private class ShimmerAnimatedView: UIView {
    private var gradientLayer = CAGradientLayer()
    private var softEdgesImageView = UIImageView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame: CGRect = .zero, color: UIColor, animationDuration: CFTimeInterval, lighterShimmer: Bool) {
        self.init(frame: frame)
        backgroundColor = color
        softenEdges(forView: self, withColor: .carbon)
        addGradientLayer(toView: self,
                              withColor: color,
                              lighterShimmer: lighterShimmer,
                              animationDuration: animationDuration)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func addGradientLayer(toView: UIView,
                                 withColor: UIColor = .white,
                                 lighterShimmer: Bool = false,
                                 animationDuration: CFTimeInterval,
                                 animated: Bool = true) {

        gradientLayer.colors = [withColor.cgColor,
                                lighterShimmer ? withColor.withAlphaComponent(0.5).lighter.cgColor :
                                                 withColor.withAlphaComponent(0.5).darker.cgColor,
                                withColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
        gradientLayer.frame = toView.bounds

        toView.layer.insertSublayer(gradientLayer, below: softEdgesImageView.layer)
        toView.layer.masksToBounds = true

        if animated {
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = animationDuration
            animation.fromValue = -toView.frame.size.width
            animation.toValue = toView.frame.size.width
            animation.repeatCount = .infinity

            gradientLayer.add(animation, forKey: "")
        }
    }

    private func softenEdges(forView: UIView,
                             withColor: UIColor = .white) {
        let gradientImage = UIImage(named: "skeletonGradient")?.resizableImage(withCapInsets: UIEdgeInsets(top: 10.0,
                                                                                                           left: 10.0,
                                                                                                           bottom: 10.0,
                                                                                                           right: 10.0),
                                                                               resizingMode: .stretch)
        softEdgesImageView = UIImageView.init(frame: forView.bounds)
        softEdgesImageView.image = gradientImage
        softEdgesImageView.tintColor = .carbon
        softEdgesImageView.contentMode = .scaleToFill
        fillOverLayerBorder(for: softEdgesImageView, superview: forView)
        softEdgesImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        softEdgesImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    func fillOverLayerBorder(for subview: UIView, superview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        if subview.superview != superview {
            superview.addSubview(subview)
        }
        superview.addConstraints([
        NSLayoutConstraint(item: subview,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: superview,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: subview,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: superview,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: subview,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: superview,
                           attribute: .width,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: subview,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: superview,
                           attribute: .height,
                           multiplier: 1,
                           constant: 0)
        ])
    }
}

// MARK: - Store/Restore BorderWidth for UIButton
private extension SkeletonManager {
    func objectAddressString(for object: UIView) -> String {
        return String(format: "%p", unsafeBitCast(object, to: Int.self))
    }

    func storeLayerBorderWidth(from button: UIButton) {
        let objectIdentifier = objectAddressString(for: button)
        originalButtonLayerBorderWidth[objectIdentifier] = button.layer.borderWidth
    }

    func restoreLayerBorderWidth(for button: UIButton) {
        let objectIdentifier = objectAddressString(for: button)
        guard let borderWidth = originalButtonLayerBorderWidth[objectIdentifier] else { return }
        button.layer.borderWidth = borderWidth
        originalButtonLayerBorderWidth[objectIdentifier] = nil // remove from dictionary
    }
}

// MARK: - UIColor
private extension UIColor {
    var lighter: UIColor {
        return adjust(by: 1.35)
    }

    var darker: UIColor {
        return adjust(by: 0.7)
    }

    func adjust(by percent: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * percent, alpha: a)
    }
}
