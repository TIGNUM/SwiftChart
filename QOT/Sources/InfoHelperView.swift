//
//  InfoHelperView.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 02/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class InfoHelperView: UIView {

    private enum TextType {
        case regular
        case title
        case description
    }

    // MARK: - Properties

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var circles: FullScreenBackgroundCircleView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var bottomInset: NSLayoutConstraint!

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
        self.fill(subview: contentView)
        setupView()
    }

    func set(icon: UIImage?, title: String?, text: String?) {
        set(icon: icon, title: title, attributedText: NSAttributedString(string: text ?? ""))
    }

    func set(icon: UIImage?, title: String?, attributedText text: NSAttributedString?) {
        iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
        titleLabel.attributedText = addDisplayAttributes(to: NSAttributedString(string: title ?? ""), type: .title)
        textLabel.attributedText = addDisplayAttributes(to: text ?? NSAttributedString(string: ""), type: .description)
    }
}

// MARK: - Private

private extension InfoHelperView {
    private func setupView() {
        self.clipsToBounds = true
        NewThemeView.dark.apply(self)
        contentView.backgroundColor = .accent04

        circles.circles = [CircleInfo(color: UIColor.sand.withAlphaComponent(0.2), radiusRate: 0.3),
                           CircleInfo(color: UIColor.sand.withAlphaComponent(0.1), radiusRate: 0.65),
                           CircleInfo(color: UIColor.sand.withAlphaComponent(0.05), radiusRate: 1)]

        iconImageView.alpha = 0.4
        ThemeTint.white.apply(iconImageView)

        titleLabel.font = .sfProDisplayLight(ofSize: 20)
        titleLabel.textColor = .white
        textLabel.font = .sfProtextLight(ofSize: 16)
        textLabel.textColor = .lightGrey
    }

    private func addDisplayAttributes(to text: NSAttributedString, type: TextType = .regular) -> NSAttributedString {
        let characterSpacing: CGFloat
        let lineSpacing: CGFloat = 6
        switch type {
        case .title:
            characterSpacing = CharacterSpacing.kern06
        case .description:
            characterSpacing = CharacterSpacing.kern1_2
        default:
            characterSpacing = .zero
        }

        let mutableText = NSMutableAttributedString(attributedString: text)
        mutableText.addAttribute(.kern, value: characterSpacing, range: NSRange(location: 0, length: text.length))

        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        mutableText.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: text.length))
        return mutableText
    }
}
