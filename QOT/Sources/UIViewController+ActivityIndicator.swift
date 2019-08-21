//
//  UIViewController+ActivityIndicator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 17/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import SVProgressHUD

enum ActivityState {
    case inProgress
    case success
    case failure
}

extension UIViewController {

    func presentActivity(state: ActivityState?) {
        if let state = state, case .inProgress = state {
            showActivity()
        } else {
            dismissActivity(with: state)
        }
    }

    func showActivity() {
        SVProgressHUD.show()
    }

    func dismissActivity(with state: ActivityState?) {
        guard let state = state else {
            SVProgressHUD.dismiss()
            return
        }

        switch state {
        case .success:
            SVProgressHUD.showSuccess(withStatus: nil)
        case .failure:
            SVProgressHUD.showError(withStatus: nil)
        case .inProgress:
            break
        }
    }
}
