//
//  Constraints+Helper.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func fromNib() -> UIView? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView else {
            return nil
        }
        self.addSubview(contentView)
        return contentView
    }
}
