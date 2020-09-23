//
//  QOTBaseHeaderView.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/10/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class QOTBaseHeaderView: UIView {

    // MARK: - Properties
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleTextView: UITextView!
    private var title: String?
    private var subtitle: String?
    private var skeletonManager = SkeletonManager()
    private var darkMode: Bool = true

    @IBOutlet private var verticalConstraints: [NSLayoutConstraint]!
    @IBOutlet private var horizontalConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var subtitleTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    func addTo(superview: UIView, showSkeleton: Bool = false, darkMode: Bool = true) {
        superview.fill(subview: self)
        self.darkMode = darkMode
        if showSkeleton {
            skeletonManager.addTitle(titleLabel)
            skeletonManager.addSubtitle(subtitleTextView)
        }
    }

    func setColor(dashColor: UIColor?, titleColor: UIColor?, subtitleColor: UIColor?) {
        if let lineColor = dashColor {
            lineView.backgroundColor = lineColor
        }
        if let titleTextColor = titleColor, title != nil,
            let attributedString = titleLabel.attributedText?.mutableCopy() as? NSMutableAttributedString {
            let range = NSRange(location: 0, length: attributedString.length)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: titleTextColor,
                                          range: range)
            titleLabel.attributedText = attributedString
        }
        if let subtitleTextColor = subtitleColor, subtitle != nil,
            let attributedString = subtitleTextView.attributedText?.mutableCopy() as? NSMutableAttributedString {
            let range = NSRange(location: 0, length: attributedString.length)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: subtitleTextColor,
                                          range: range)
            subtitleTextView.attributedText = attributedString
        }
    }

    func configure(title: String?, subtitle: String?, darkMode: Bool? = true, animated: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        if subtitle == nil, subtitleTextView != nil {
            let heightConstraint = NSLayoutConstraint.init(item: subtitleTextView!,
                                                           attribute: .height,
                                                           relatedBy: .equal,
                                                           toItem: nil,
                                                           attribute: .notAnAttribute,
                                                           multiplier: 1.0,
                                                           constant: 0.0)
            subtitleTextView.addConstraint(heightConstraint)
            subtitleTextViewBottomConstraint.constant = 0
        }
        skeletonManager.hide()
        subtitleTextView.textContainerInset = .zero
        subtitleTextView.textContainer.lineFragmentPadding = 0
        refresh(darkMode: darkMode, animated: animated)
    }

    func configure(title: String?, subtitle: NSAttributedString) {
        ThemeText.baseHeaderTitle(.dark).apply(title, to: titleLabel)
        subtitleTextView.attributedText = subtitle
    }

    func refresh(darkMode: Bool? = nil, animated: Bool = false) {
        let mode: ThemeColorMode = darkMode ?? self.darkMode ? .dark : .light
        ThemeView.baseHeaderLineView(mode).apply(lineView)
        ThemeText.baseHeaderTitle(mode).apply(title, to: titleLabel)
        ThemeText.baseHeaderSubtitle(mode).apply(subtitle, to: subtitleTextView)
    }

    func refresh(titleThemeText: ThemeText, subtitleThemeText: ThemeText?) {
        titleThemeText.apply(title, to: titleLabel)
        subtitleThemeText?.apply(subtitle, to: subtitleTextView)
    }
}

extension QOTBaseHeaderView {
    static func instantiateBaseHeader(superview: UIView, showSkeleton: Bool = false, darkMode: Bool = true) -> QOTBaseHeaderView {
        let headerView = R.nib.qotBaseHeaderView.firstView(owner: superview)
        headerView?.addTo(superview: superview, showSkeleton: showSkeleton, darkMode: darkMode)

        return headerView ?? QOTBaseHeaderView.init(frame: .zero)
    }

    // MARK: Public

    func calculateHeight(for cellWidth: CGFloat, _ defaultHeight: CGFloat? = 16) -> CGFloat {
        var height: CGFloat = defaultHeight ?? 0
        var verticalConstraintsSum: CGFloat = 0
        var horizontalConstraintsSum: CGFloat = 0
        for constraint in verticalConstraints {
            verticalConstraintsSum += constraint.constant
        }
        for constraint in horizontalConstraints {
            horizontalConstraintsSum += constraint.constant
        }
        let titleLabelSize = titleLabel.sizeThatFits(CGSize(width: cellWidth - horizontalConstraintsSum,
                                                            height: .greatestFiniteMagnitude))
        var subtitleLabelSize = subtitleTextView.sizeThatFits(CGSize(width: cellWidth - horizontalConstraintsSum,
                                                                     height: .greatestFiniteMagnitude))
        if subtitleTextView.text.isEmpty {
            subtitleLabelSize = .zero
        }
        height = height + titleLabelSize.height + subtitleLabelSize.height + verticalConstraintsSum
        return height
    }
}
