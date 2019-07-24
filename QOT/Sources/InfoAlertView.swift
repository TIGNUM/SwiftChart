//
//  InfoAlertView.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

/**
 `InfoAlertView` allows for simple display of QOT style alerts. It contains an icon - displayed inside three concentrical
 circles - title and text. Is supports sever presentation styles defined in `InfoAlertView.Style`.

 Example usage:

 It's best to declare the `InfoAlertView` as a global property.

 `onDismiss` closure should be used with presentation style `halfScreenBlur`, as the user can dismiss the alert
 internally by tapping on blur or swiping down so the owner is notified of this event through the closure.

 infoAlertView = InfoAlertView()
 infoAlertView?.set(icon: icon, title: title, text: text)
 infoAlertView?.present(on: self.view)
 infoAlertView?.topInset = 64
 infoAlertView?.bottomInset = BottomNavigationContainer.height
 infoAlertView?.setBackgroundColor(UIColor.carbon.withAlphaComponent(95))
 infoAlertView?.style = .halfScreenBlur
 infoAlertView?.onDismiss = {
    self.infoAlertView = nil
    self.dismissAlert()
 }
 */
class InfoAlertView: UIView {
    /// InfoAlertView presentation styles
    enum Style {
        /// Solid background throughout the whole screen. Text content and icon are aligned to the bottom of the screen.
        case regular
        /// Top half of the screen is blurred. Text content (without the icon) having solid background is aligned to the
        /// top of the bottom half of the screen.
        case halfScreenBlur
    }

    typealias DismissClosure = (() -> Void)

    /// Private enum defining text type for easier styling
    private enum TextType {
        case regular
        case title
        case description
    }

    /// Animation duration
    private static let duration: Double = 0.12

    // UI properties
    @IBOutlet private var containerView: UIView!

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet private weak var blurView: UIVisualEffectView!

    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var infoViewTopConstraint: NSLayoutConstraint!

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var circles: FullScreenBackgroundCircleView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var textBottomConstraint: NSLayoutConstraint!

    @IBOutlet private weak var dragIndicator: UIView!
    @IBOutlet private weak var dragView: UIButton!

    // Touch locations used in `halfScreenBlur` appearance
    private var initialLocation: CGFloat = 0
    private var lastLocation: CGFloat = 0

    /// Closure to be executed when the alert is dismissed. Important for `halfScreen` style as user can dismiss the
    /// alert by tapping on blur or swiping down
    var onDismiss: DismissClosure?

    /// Designates content distance to the top of the superview. Ignored if style is not `regular`.
    var topInset: CGFloat = 0 {
        didSet {
            contentViewTopConstraint.constant = self.topInset
            setNeedsLayout()
        }
    }

    /// Designates content distance to the bottom of the superview. Default value is `BottomNavigationContainer.height`.
    /// Ignored if style is not `regular`.
    var bottomInset: CGFloat = BottomNavigationContainer.height {
        didSet {
            contentViewBottomConstraint.constant = self.bottomInset
            setNeedsLayout()
        }
    }

    /// Presentation style
    var style: Style = .regular {
        didSet {
            updateUI()
        }
    }

    convenience init() {
        self.init(frame: .zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        fill(subview: containerView)
        dragIndicator.layer.cornerRadius = dragIndicator.frame.size.height/2.0

        infoView.backgroundColor = .carbon
        contentView.backgroundColor = .accent04

        circles.circles = [CircleInfo(color: UIColor.sand.withAlphaComponent(0.2), radiusRate: 0.3),
                           CircleInfo(color: UIColor.sand.withAlphaComponent(0.1), radiusRate: 0.65),
                           CircleInfo(color: UIColor.sand.withAlphaComponent(0.05), radiusRate: 1)]

        iconImageView.alpha = 0.4
        iconImageView.tintColor = .sand

        titleLabel.font = .sfProDisplayLight(ofSize: 20)
        titleLabel.textColor = .sand
        textLabel.font = .sfProtextLight(ofSize: 16)
        textLabel.textColor = .sand70
    }
}

// MARK: - UI updates
extension InfoAlertView {
    private func updateUI() {
        switch style {
        case .regular:
            break
        case .halfScreenBlur:
            applyHalfScreenUI()
        }
    }

    private func applyHalfScreenUI() {
        // Reduce info content size to half screen
        infoViewTopConstraint.constant = (self.containerView.frame.size.height - topInset)/2

        // Show additional views
        blurView.isHidden = false
        blurView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(internalDismiss))]
        dragView.isHidden = false
        dragView.gestureRecognizers = [UIPanGestureRecognizer(target: self, action: #selector(detectedPan(_:)))]

        // Align texts to top of the info container
        circles.isHidden = true
        textBottomConstraint.isActive = false
        titleLabel.topAnchor.constraint(equalTo: dragView.bottomAnchor, constant: 30).isActive = true

        // Remember initial location for swiping
        initialLocation = containerView.convert(dragView.frame.center, to: contentView).y
    }
}

// MARK: - Public interface
extension InfoAlertView {
    func set(icon: UIImage?, title: String?, text: String?) {
        set(icon: icon, title: title, attributedText: NSAttributedString(string: text ?? ""))
    }

    func set(icon: UIImage?, title: String?, attributedText text: NSAttributedString?) {
        iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
        titleLabel.attributedText = addDisplayAttributes(to: NSAttributedString(string: title ?? ""), type: .title)
        textLabel.attributedText = addDisplayAttributes(to: text ?? NSAttributedString(string: ""), type: .description)
    }

    func present(on view: UIView, animated: Bool = true) {
        self.alpha = 0
        view.addSubview(self)
        self.addConstraints(to: view)
        UIView.animate(withDuration: duration(animated)) { [weak self] in
            self?.alpha = 1
        }
    }

    func dismiss(animated: Bool = true) {
        UIView.animate(withDuration: duration(animated), animations: { [weak self] in
            self?.alpha = 0
        }, completion: {  [weak self] (completion) in
            self?.onDismiss?()
            self?.removeFromSuperview()
        })
    }

    func setBackgroundColor(_ color: UIColor?) {
        infoView.backgroundColor = color
    }
}

// MARK: - Dragging
extension InfoAlertView {

    @objc func detectedPan(_ recognizer: UIPanGestureRecognizer) {
        let offset  = recognizer.translation(in: contentView).y - initialLocation

        // Do not drag up
        if offset < 0 {
            return
        }

        // Handle gesture end
        if recognizer.state == .ended {
            handlePanEnd(offset: offset)
            return
        }

        // Handle drag down
        self.alpha = 1.0 - 0.4 * (offset / infoView.frame.size.height) // Min. alpha during swiping is 60 %
        infoView.transform = CGAffineTransform.init(translationX: 0, y: offset)
    }

    private func handlePanEnd(offset: CGFloat) {
        if fabs(offset) > 0.25*infoView.frame.size.height {
            internalDismiss()
            return
        }

        UIView.animate(withDuration: InfoAlertView.duration) { [weak self] in
            self?.infoView.transform = .identity
            self?.alpha = 1
        }
    }
}

// MARK: - Private methods
extension InfoAlertView {

    @objc private func internalDismiss() {
        dismiss()
    }

    private func duration(_ animated: Bool) -> Double {
        return (animated ? InfoAlertView.duration : 0.0)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let convertedPoint = containerView.convert(point, to: contentView)
        return contentView.point(inside: convertedPoint, with: event)
    }

    private func addDisplayAttributes(to text: NSAttributedString, type: TextType = .regular) -> NSAttributedString {
        let characterSpacing: CGFloat
        let lineSpacing: CGFloat = 6
        switch type {
        case .title:
            characterSpacing = 0.6
        case .description:
            characterSpacing = 1.2
        case .regular:
            characterSpacing = 0
        }

        let mutableText = NSMutableAttributedString(attributedString: text)
        mutableText.addAttribute(.kern, value: characterSpacing, range: NSRange(location: 0, length: text.length))

        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        mutableText.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: text.length))
        return mutableText
    }
}
