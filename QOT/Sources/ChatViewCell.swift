//
//  ChatViewCell.swift
//  QOT
//
//  Created by Sam Wyndham on 27.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class ChatViewCell: UICollectionViewCell {

    struct Style {
        let identifier: String
        let backgroundColor: UIColor
        let dashedLineColor: UIColor
        let dashedLineWidth: CGFloat
        let dashedLinePattern: [NSNumber]?
        let textAttributes: [NSAttributedStringKey: Any]

        static let message: Style = {
            return Style(identifier: "message",
                         backgroundColor: .white,
                         dashedLineColor: .white,
                         dashedLineWidth: 0,
                         dashedLinePattern: nil,
                         textAttributes: Style.attributes(font: .bentonBookFont(ofSize: 17), textColor: .black))
        }()

        static let choiceUnselected: Style = {
            return Style(identifier: "choiceUnselected",
                         backgroundColor: .black40,
                         dashedLineColor: .greyish20,
                         dashedLineWidth: 1,
                         dashedLinePattern: [4, 3],
                         textAttributes: Style.attributes(font: .bentonBookFont(ofSize: 17), textColor: .white60))
        }()

        static let choiceSelected: Style = {
            return Style(identifier: "choiceSelected",
                         backgroundColor: .black40,
                         dashedLineColor: .greyish20,
                         dashedLineWidth: 1,
                         dashedLinePattern: nil,
                         textAttributes: Style.attributes(font: .bentonBookFont(ofSize: 17), textColor: .white))
        }()

        static let visionChoiceSelected: Style = {
            return Style(identifier: "choiceSelected",
                         backgroundColor: .azure,
                         dashedLineColor: .greyish20,
                         dashedLineWidth: 1,
                         dashedLinePattern: nil,
                         textAttributes: Style.attributes(font: .bentonBookFont(ofSize: 17), textColor: .white))
        }()

        static func attributes(font: UIFont, textColor: UIColor, lineSpacing: CGFloat = 7)
            -> [NSAttributedStringKey: Any] {
                let style = NSMutableParagraphStyle()
                style.lineSpacing = lineSpacing
                return [.paragraphStyle: style.copy(), .font: font, .foregroundColor: textColor]
        }
    }

    let typingBackgroundView = UIView()
    let typingAnimationView = UIImageView()
    let label = UILabel()
    let dashedLineView = DashedLineView()
    private var animator: ChatViewAnimator?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String, style: Style) {
        dashedLineView.backgroundColor = style.backgroundColor
        dashedLineView.strokeColor = style.dashedLineColor
        dashedLineView.lineWidth = style.dashedLineWidth
        dashedLineView.lineDashPattern = style.dashedLinePattern
        label.attributedText = NSAttributedString(string: text, attributes: style.textAttributes)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        if let attrs = layoutAttributes as? ChatViewLayoutAttibutes, let animator = attrs.animator, self.animator == nil {
            self.animator = animator
            animator.animate(view: self, using: attrs)
        }

    }

    override func prepareForReuse() {
        super.prepareForReuse()

        animator?.cancel()
        animator = nil
    }

    private func setup() {
        contentView.addSubview(typingBackgroundView)
        contentView.addSubview(typingAnimationView)
        contentView.addSubview(dashedLineView)
        contentView.addSubview(label)

        backgroundColor = .clear
        typingBackgroundView.backgroundColor = .white
        typingBackgroundView.layer.cornerRadius = 10
        typingBackgroundView.layer.opacity = 0
        typingAnimationView.contentMode = .center
        typingAnimationView.layer.opacity = 0
        typingAnimationView.backgroundColor = .clear
        typingAnimationView.animationImages = typingAnimationImages()
        typingAnimationView.animationRepeatCount = 1
        label.numberOfLines = 0
        label.backgroundColor = .clear
        dashedLineView.cornerRadius = 10

        typingBackgroundView.edgeAnchors == contentView.edgeAnchors
        typingAnimationView.leftAnchor == contentView.leftAnchor
        typingAnimationView.topAnchor == contentView.topAnchor
        typingAnimationView.widthAnchor == 60
        typingAnimationView.heightAnchor == 40
        dashedLineView.edgeAnchors == contentView.edgeAnchors
        label.horizontalAnchors == contentView.horizontalAnchors + 12 ~ Priority.custom(LayoutPriority(rawValue: 999))
        label.topAnchor == contentView.topAnchor + 12
        label.bottomAnchor == contentView.bottomAnchor - 12 ~ Priority.custom(LayoutPriority(rawValue: 999))
    }

    func typingAnimationImages() -> [UIImage] {
        var images: [UIImage] = []
        for index in 0...27 {
            let name = String(format: "%05d_QOT_DOTS", index)
            guard let image = UIImage(named: name) else {
                fatalError("missing image")
            }
            images.append(image)
        }
        return images
    }
}

final class DashedLineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var lineWidth: CGFloat {
        get { return shapeLayer.lineWidth }
        set { shapeLayer.lineWidth = newValue }
    }

    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    var lineDashPattern: [NSNumber]? {
        get { return shapeLayer.lineDashPattern }
        set { shapeLayer.lineDashPattern = newValue }
    }

    var strokeColor: UIColor? {
        get { return shapeLayer.strokeColor.map { UIColor(cgColor: $0) } }
        set { shapeLayer.strokeColor = newValue?.cgColor }
    }

    override var backgroundColor: UIColor? {
        get { return super.backgroundColor }
        set {
            super.backgroundColor = newValue
            shapeLayer.backgroundColor = newValue?.cgColor
            shapeLayer.fillColor = newValue?.cgColor
        }
    }

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let lineWidth = shapeLayer.lineWidth
        let pathFrame = CGRect(x: lineWidth / 2,
                               y: lineWidth / 2,
                               width: bounds.width - lineWidth,
                               height: bounds.height - lineWidth)
        shapeLayer.path = UIBezierPath(roundedRect: pathFrame, cornerRadius: layer.cornerRadius).cgPath
    }

    private func setup() {
        lineWidth = 1
        cornerRadius = 0
        lineDashPattern = [4, 3]
        strokeColor = .black
        backgroundColor = .white
    }

    private var shapeLayer: CAShapeLayer {
        guard let shapeLayer = layer as? CAShapeLayer else {
            fatalError("Incorrect layer type")
        }
        return shapeLayer
    }
}
