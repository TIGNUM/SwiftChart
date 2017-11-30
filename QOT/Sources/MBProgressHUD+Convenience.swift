//
//  MBProgressHUD+Convenience.swift.swift
//  QOT
//
//  Created by Lee Arromba on 02/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import MBProgressHUD

extension MBProgressHUD {

    class func showAdded(to view: UIView, animated: Bool, title: String?, message: String?) -> MBProgressHUD {
        let hud = showAdded(to: view, animated: animated)
        hud.label.text = title
        hud.detailsLabel.text = message
        hud.minShowTime = 1
        hud.graceTime = 0
        hud.mode = .indeterminate
        hud.animationType = .fade
        hud.isSquare = false

        return hud
    }
}
