//
//  AnimatedLaunchScreenViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 7/11/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class AnimatedLaunchScreenViewController: UIViewController {

    // MARK: - Properties

    private let backGroundImageView = UIImageView(image: UIImage())
    private let bottomLabel = UILabel()
    private var logoImageView = UIImageView()
    private let imageCount = 92

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomLabel.setAttrText(text: R.string.localized.splashViewRuleYourImpact(),
                                font: UIFont.H5SecondaryHeadline,
                                color: .white60)
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Public

    func fadeInLogo(withCompletion completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 2, animations: {
            self.logoImageView.alpha = 1
        }, completion: { (_: Bool) in
            completion?()
        })
    }

    func fadeOutLogo(withCompletion completion: (() -> Void)? = nil) {

        UIView.animate(withDuration: 0.5, animations: {
            self.logoImageView.alpha = 0
            self.bottomLabel.alpha = 0
        }, completion: { (_: Bool) in
            completion?()
        })
    }

    func startAnimatingImages(withCompletion completion: (() -> Void)? = nil) {
        logoImageView.startAnimating()
        let estimatedTime = Double(imageCount) * (1 / 30) // 30 fps. @see UIImageView animationDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + estimatedTime) {
            completion?()
        }
    }
}

private extension AnimatedLaunchScreenViewController {

    func setupHierarchy() {
        view.backgroundColor = .navy
        view.addSubview(backGroundImageView)
        view.addSubview(bottomLabel)
        view.addSubview(logoImageView)
        configureAnimation()
    }

    func setupLayout() {
        backGroundImageView.horizontalAnchors == view.horizontalAnchors
        backGroundImageView.verticalAnchors == view.verticalAnchors
        bottomLabel.bottomAnchor == view.bottomAnchor - 34
        bottomLabel.centerXAnchor == view.centerXAnchor
        logoImageView.heightAnchor == 48
        logoImageView.widthAnchor == 138
        logoImageView.centerAnchors == view.centerAnchors
        view.layoutIfNeeded()
    }

    func configureAnimation() {
        let images = logoImages()
        logoImageView.alpha = 0
        logoImageView.image = images.last
        logoImageView.animationImages = images
        logoImageView.animationRepeatCount = 1
    }

    func logoImages() -> [UIImage] {
        var images = [UIImage?]()
        for index in 0..<imageCount {
            let imageName = "\(String(format: "%05d", index))_QOT_LOGO"
            images.append(UIImage(named: imageName))
        }
        return images.compactMap { $0 }
    }
}
