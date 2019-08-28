//
//  ComponentCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 25.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class ComponentCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var componentContentView: ComponentContentView!
    var disabledHighlightedAnimation = false

    override func awakeFromNib() {
        super.awakeFromNib()
        componentContentView.layer.masksToBounds = true

        contentView.backgroundColor = .clear
        ThemeView.level1.apply(self)

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .init(width: 0, height: 4)
        layer.shadowRadius = 12
    }

    func resetTransform() {
        transform = .identity
    }

    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }

    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }

//    func configure(title: String,
//                   image: URL?,
//                   author: String,
//                   publishDate: Date?,
//                   timeToRead: String?) {
//        componentContentView.configure(title: title,
//                                       image: image,
//                                       author: author,
//                                       publishDate: publishDate,
//                                       timeToRead: timeToRead)
//    }

    // Make it appears very responsive to touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }

    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation {
            return
        }
        let animationOptions: UIViewAnimationOptions = GlobalConstants.isEnabledAllowsUserInteractionWhileHighlightingCard
            ? [.allowUserInteraction] : []
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .init(scaleX: GlobalConstants.cardHighlightedFactor,
                                                   y: GlobalConstants.cardHighlightedFactor)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }
}
