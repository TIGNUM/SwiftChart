//
//  ComponentContentView.swift
//  QOT
//
//  Created by karmic on 25.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol NibLoadable where Self: UIView {

    /// Setup this view with nib:
    /// 1. Load content view from nib (with the class name)
    /// 2. Set owner to self
    /// 3. Add it as a subview and fill edges with AutoLayout
    func fromNib() -> UIView?
}

extension NibLoadable {
    @discardableResult
    func fromNib() -> UIView? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView else {
            return nil
        }
        self.addSubview(contentView)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.edges(to: self)
        return contentView
    }
}

extension UIView {
    /// Constrain 4 edges of `self` to specified `view`.
    func edges(to view: UIView, top: CGFloat=0, left: CGFloat=0, bottom: CGFloat=0, right: CGFloat=0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
            ])
    }
}

class ComponentContentView: UIView {

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        fromNib()
////        commonSetup()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        fromNib()
////        commonSetup()
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
////        commonSetup()
//    }

//    private func commonSetup() {
//        // *Make the background image stays still at the center while we animationg,
//        // else the image will get resized during animation.
//        imageView.contentMode = .center
////        setFontState(isHighlighted: false)
//    }

//    func configure(title: String,
//                   image: URL?,
//                   author: String,
//                   publishDate: Date?,
//                   timeToRead: String?) {
//        titleLabel.text = title
//        imageView.kf.setImage(with: image, placeholder: R.image.preloading())
//        authorLabel.text = author
//        publishDateLabel.text = publishDate?.description
//        timeToReadLabel.text = timeToRead
//    }
}
