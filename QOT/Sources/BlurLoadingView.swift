//
//  BlurLoadingView.swift
//  QOT
//
//  Created by Lee Arromba on 09/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class BlurLoadingView: UIView {
    
    private let activityIndicatorView: UIActivityIndicatorView
    private let label: UILabel = UILabel()

    init(lodingText: String, activityIndicatorStyle: UIActivityIndicatorViewStyle) {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorStyle)
        super.init(frame: .zero)
        setup(lodingText: lodingText)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private

    private func setup(lodingText: String) {
        backgroundColor = .navy
        activityIndicatorView.startAnimating()
        label.text = lodingText
        label.font = .DPText2
        label.textColor = .white
        label.numberOfLines = 0
        addSubview(activityIndicatorView)
        addSubview(label)
        activityIndicatorView.centerAnchors == centerAnchors
        label.centerXAnchor == activityIndicatorView.centerXAnchor
        label.topAnchor == activityIndicatorView.bottomAnchor + 20
        label.horizontalAnchors >= horizontalAnchors + 10
    }
}
