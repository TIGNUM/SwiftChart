//
//  ChatViewHeaderFooter.swift
//  QOT
//
//  Created by Sam Wyndham on 29.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class ChatViewHeaderFooter: UICollectionReusableView {

    struct Style {
        let textAttributes: [NSAttributedStringKey: Any]
        static func `default`(alignment: NSTextAlignment) -> Style {
            let style = NSMutableParagraphStyle()
            style.alignment = alignment
            let attrs: [NSAttributedStringKey: Any] = [.paragraphStyle: style.copy(),
                                                       .font: UIFont.H7Tag,
                                                       .foregroundColor: UIColor.whiteLight40]
            return Style(textAttributes: attrs)
        }
    }

    private let label = UILabel()
    private var animator: ChatViewAnimator?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String, style: Style) {
        label.attributedText = NSAttributedString(string: text, attributes: style.textAttributes)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attrs = layoutAttributes as? ChatViewLayoutAttibutes, let animator = attrs.animator {
            self.animator = animator
            animator.animate(view: self, using: attrs)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        animator?.cancel()
    }

    private func setup() {
        addSubview(label)
        label.numberOfLines = 0
        label.edgeAnchors == edgeAnchors
    }
}
