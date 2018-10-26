//
//  PageIndicatorItemView.swift
//  RatingAnimation
//
//  Created by Sanggeon Park on 24.10.18.
//  Copyright © 2018 Sanggeon Park. All rights reserved.
//

import UIKit

class PageIndicatorItemView: UIView {
    @IBOutlet weak private var titleLabel: UILabel!
    private var selected: Bool = false
    private var enabled: Bool = false
    private var title: String?

    static func viewWithTitle(_ title: String?) -> PageIndicatorItemView? {
        guard let item = Bundle.main.loadNibNamed("PageIndicatorItemView", owner: self, options: nil)?.first,
            let view = item as? PageIndicatorItemView else {
            return nil
        }
        view.setTitle(title)
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.layer.cornerRadius = 0.5 * titleLabel.bounds.size.width
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.borderWidth = 2.0
    }

    public func enable(_ enable: Bool) {
        enabled = enable
        titleLabel.backgroundColor = enable == true ? UIColor.clear : UIColor.gray
        titleLabel.textColor = enable == true ? UIColor.gray : UIColor.clear
        titleLabel.layer.borderColor = UIColor.gray.cgColor
    }

    public func select(_ select: Bool) {
        guard enabled == true else { return }
        selected = select
        titleLabel.backgroundColor = select == true ? UIColor.white : UIColor.clear
        titleLabel.layer.borderColor = select == true ? UIColor.white.cgColor : UIColor.gray.cgColor
        titleLabel.textColor = select == true ? UIColor.black : UIColor.gray
    }

    public func setTitle(_ title: String?) {
        self.title = title
        self.titleLabel.text = title
    }
}
