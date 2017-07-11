//
//  UIView+ProgressHUD.swift
//  QOT
//
//  Created by Moucheg Mouradian on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIView {

    /**
     * type: Message type
     * completionBlock: Action to exectue after the HUD has been dismissed
     * actionBlock: Action to execute
     */
    func showProgressHUD(type: AlertType, completionBlock: @escaping MBProgressHUDCompletionBlock = {}, actionBlock: @escaping () -> Void) {

        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.label.text = type.title
        hud.detailsLabel.text = type.message
        hud.minShowTime = type.minShowTime
        hud.graceTime = type.graceTime
        hud.mode = type.mode
        hud.animationType = type.animationType
        hud.isSquare = type.isSquare
        hud.completionBlock = completionBlock

        DispatchQueue.global(qos: .background).async {
            actionBlock()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
        
    }
}
