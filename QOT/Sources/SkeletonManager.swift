//
//  SkeletonManager.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class SkeletonManager: NSObject {
    /**
     In order to use this manager to apply skeleton loading feature to different views all you have to do is call the addTitle, addSubtitle or addOtherView methods.
     This will automatically setup the skeleton according to the type of view and start animating it

     When the data has been loaded, in order to stop the skeleton hide() must be called

 */
    // MARK: Properties
    private var skeletonableTitles: [UIView] = []
    private var skeletonableSubtitles: [UIView] = []
    private var skeletonableOtherViews: [UIView] = []
    static let shimmerAnimationDuration: CFTimeInterval = 1.5
    static let dissolveAnimationDuration: Double = 0.75

    // MARK: Lifecycle
    deinit {
        hide()
    }

    // MARK: Public
    func addTitle(_ view: UIView) {
        skeletonableTitles.append(view)
        addShimmerView(to: view, withBackgroundColor: .skeletonTitleColor, lighterShimmer: true)
    }

    func addSubtitle(_ view: UIView) {
        skeletonableSubtitles.append(view)
        addShimmerView(to: view, withBackgroundColor: .skeletonSubtitleColor, lighterShimmer: true)
    }

    func addOtherView(_ view: UIView) {
        skeletonableOtherViews.append(view)
        addShimmerView(to: view, withBackgroundColor: .skeletonOtherViewsColor, lighterShimmer: true)
    }

    func hide() {
        for view in self.skeletonableTitles {
            self.removeShimmerView(from: view, withAnimationDuration: SkeletonManager.dissolveAnimationDuration)
        }
        for view in self.skeletonableSubtitles {
            self.removeShimmerView(from: view, withAnimationDuration: SkeletonManager.dissolveAnimationDuration)
        }

        for view in self.skeletonableOtherViews {
            self.removeShimmerView(from: view, withAnimationDuration: SkeletonManager.dissolveAnimationDuration)
        }
        self.skeletonableTitles.removeAll()
        self.skeletonableSubtitles.removeAll()
        self.skeletonableOtherViews.removeAll()
    }

    // MARK: Private
    private func addShimmerView(to view: UIView, withBackgroundColor: UIColor, lighterShimmer: Bool) {
        if view.isKind(of: UIButton.self) {
            guard let button = view as? UIButton else { return }
            button.titleLabel?.isHidden = true
            button.layer.borderWidth = 0
        }
        let shimmerView = ShimmerAnimatedView.init(frame: view.frame, color: withBackgroundColor, animationDuration: SkeletonManager.shimmerAnimationDuration, lighterShimmer: lighterShimmer)
        shimmerView.isUserInteractionEnabled = true
        UIView.transition(with: view, duration: SkeletonManager.dissolveAnimationDuration, options: [.transitionCrossDissolve], animations: {
            shimmerView.fillOverLayerBorder(withSuperview: view)
            view.bringSubview(toFront: shimmerView)
        }, completion: nil)
    }

    private func removeShimmerView(from view: UIView, withAnimationDuration: Double) {
        for shimmerView in view.subviews where shimmerView as? ShimmerAnimatedView != nil {
            if let button = view as? UIButton {
                button.titleLabel?.isHidden = false
                button.layer.borderWidth = 1
            }
            UIView.transition(with: view, duration: withAnimationDuration, options: [.transitionCrossDissolve], animations: {
                shimmerView.removeFromSuperview()
            }, completion: nil)
        }
    }
}

private class ShimmerAnimatedView: UIView {
    private var gradientLayer = CAGradientLayer()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame: CGRect = .zero, color: UIColor, animationDuration: CFTimeInterval, lighterShimmer: Bool) {
        self.init(frame: frame)
        self.backgroundColor = color
        self.addGradientLayer(toView: self,
                              withColor: color,
                              lighterShimmer: lighterShimmer,
                              animationDuration: animationDuration)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }

    private func addGradientLayer(toView: UIView,
                                 withColor: UIColor = .white,
                                 lighterShimmer: Bool = false,
                                 animationDuration: CFTimeInterval = SkeletonManager.shimmerAnimationDuration,
                                 animated: Bool = true) {

        gradientLayer.colors = [withColor.cgColor,
                                lighterShimmer ? withColor.lighter.cgColor : withColor.darker.cgColor,
                                withColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = toView.bounds
        toView.layer.addSublayer(gradientLayer)
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

    func fillOverLayerBorder(withSuperview: UIView) {
        if self.superview != withSuperview {
            withSuperview.addSubview(self)
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: withSuperview,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: self,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: withSuperview,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: self,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: withSuperview,
                           attribute: .width,
                           multiplier: 1,
                           constant: 2).isActive = true
        NSLayoutConstraint(item: self,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: withSuperview,
                           attribute: .height,
                           multiplier: 1,
                           constant: 2).isActive = true
    }
}

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
