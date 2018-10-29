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
    @IBOutlet weak private var titleLabelCenter: NSLayoutConstraint!
    @IBOutlet weak private var underbarWidth: NSLayoutConstraint!
    private var selected: Bool = false
    private var enabled: Bool = false
    private var title: String?
    private var itemIdentifier: Int?
    private var action: ((_ itemIdentifier: Int) -> Void)? = nil

    static func viewWithTitle(_ title: String?,
                              _ itemIdentifier: Int?,
                              _ action: ((_ itemIdentifier: Int) -> Void)?) -> PageIndicatorItemView? {
        guard let item = Bundle.main.loadNibNamed("PageIndicatorItemView", owner: self, options: nil)?.first,
            let view = item as? PageIndicatorItemView else {
            return nil
        }
        view.setTitle(title)
        view.itemIdentifier = itemIdentifier
        view.action = action
        return view
    }

    @IBAction func didSelected() {
        guard let itemID = itemIdentifier, enabled == true else { return }
        action?(itemID)
    }

    public func enable(_ enable: Bool) {
        enabled = enable
        self.titleLabel.textColor = enabled == true ? UIColor.white : UIColor.white40
    }

    public func select(_ select: Bool) {
        guard enabled == true else { return }
        selected = select

        UIView.animate(withDuration: Animation.duration) {
            self.underbarWidth.constant = self.selected == false ?  0 : Layout.padding_16
            self.titleLabelCenter.constant = self.selected == false ? 0 : -Layout.padding_5
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }
    }

    public func setTitle(_ title: String?) {
        self.title = title
        self.titleLabel.text = title
    }
}
