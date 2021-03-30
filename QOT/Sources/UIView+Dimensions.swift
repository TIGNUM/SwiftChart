//
//  UIView+Dimensions.swift
//  QOT
//
//  Created by karmic on 30.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import Foundation

extension UIView {
    var size: CGSize {
        return CGSize(width: fwidth, height: fheight)
    }

    var fwidth: CGFloat {
        return frame.width
    }

    var fheight: CGFloat {
        return frame.height
    }

    var bwidth: CGFloat {
        return bounds.width
    }

    var bheight: CGFloat {
        return bounds.height
    }
}
