//
//  FullScreenLoadable.swift
//  QOT
//
//  Created by Lee Arromba on 14/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol FullScreenLoadable: class {
    var isLoading: Bool { get set }
    var loadingView: BlurLoadingView? { get set }
    var view: UIView! { get set }
    
    func showLoading(_ isLoading: Bool, text: String?)
}

extension FullScreenLoadable {
    func showLoading(_ isLoading: Bool, text: String?) {
        if isLoading {
            guard self.loadingView == nil else { return }
            let loadingView = BlurLoadingView(
                lodingText: text ?? "",
                activityIndicatorStyle: .whiteLarge
            )
            loadingView.alpha = 0.0
            view.addSubview(loadingView)
            loadingView.horizontalAnchors == view.horizontalAnchors
            loadingView.verticalAnchors == view.verticalAnchors
            loadingView.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                loadingView.alpha = 1.0
            })
            self.loadingView = loadingView
        } else {
            guard let loadingView = self.loadingView else { return }
            UIView.animate(withDuration: 0.5, animations: {
                loadingView.alpha = 0.0
            }, completion: { _ in
                loadingView.removeFromSuperview()
                self.loadingView = nil
            })
        }
    }
}
