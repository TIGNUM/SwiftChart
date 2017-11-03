//
//  LoadingViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 7/12/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class LoadingViewController: UIViewController {

    private var myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    private var backgroundImageView = UIImageView()

    private var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .white
        label.font = Font.H3Subtitle
        return label
    }()

    init(backgroundImage: UIImage? = R.image._1_1Learn(), message: String = R.string.localized.loadingViewMessage()) {

        super.init(nibName: nil, bundle: nil)
        setupHierarchy()
        setupLayout()
        if let image = backgroundImage {
            setup(image: image, message: message)
        }
        myActivityIndicator.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fadeIn(withCompletion completion: (() -> Void)? = nil) {
        messageLabel.alpha = 0.0
        myActivityIndicator.alpha = 0.0
        UIView.animate(withDuration: 1.0, animations: {
            self.messageLabel.alpha = 1.0
            self.myActivityIndicator.alpha = 1.0
        }, completion: { (_: Bool) in
            completion?()
        })
    }
    
    func fadeOut(withCompletion completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 1.0, animations: {
            self.messageLabel.alpha = 0.0
            self.myActivityIndicator.alpha = 0.0
        }, completion: { (_: Bool) in
            completion?()
        })
    }
}

private extension LoadingViewController {

    func setupHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(myActivityIndicator)
        view.addSubview(messageLabel)
    }

    func setupLayout() {
        backgroundImageView.horizontalAnchors == view.horizontalAnchors
        backgroundImageView.verticalAnchors == view.verticalAnchors

        myActivityIndicator.horizontalAnchors == view.horizontalAnchors
        myActivityIndicator.heightAnchor == 50
        myActivityIndicator.centerAnchors == view.centerAnchors

        messageLabel.topAnchor == myActivityIndicator.bottomAnchor
        messageLabel.leftAnchor == view.leftAnchor + 40
        messageLabel.rightAnchor == view.rightAnchor - 40
        messageLabel.bottomAnchor == view.bottomAnchor

        view.layoutIfNeeded()
    }

    func setup(image: UIImage, message: String) {
        backgroundImageView.image = image
        messageLabel.text = message
    }
}
