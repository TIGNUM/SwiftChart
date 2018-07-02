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

    private let backGroundImageView = UIImageView(image: R.image._1_1Learn())
    private let tignumImageView = UIImageView(image: R.image.byTignum())
    private var logoImageView = UIImageView()
    private let imageCount = 92

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Public

    func fadeInLogo(withCompletion completion: (() -> Void)? = nil) {
        #if DEBUG
            completion?()
            return
        #else
        UIView.animate(withDuration: 2, animations: {
            self.logoImageView.alpha = 1
        }, completion: { (_: Bool) in
            completion?()
        })
        #endif // #if DEBUG
    }

    func fadeOutLogo(withCompletion completion: (() -> Void)? = nil) {
        #if DEBUG
            completion?()
            return
        #else
        UIView.animate(withDuration: 0.5, animations: {
            self.logoImageView.alpha = 0
        }, completion: { (_: Bool) in
            completion?()
        })
        #endif // #if DEBUG
    }

    func startAnimatingImages(withCompletion completion: (() -> Void)? = nil) {
        #if DEBUG
            completion?()
            return
        #else
        logoImageView.startAnimating()
        let estimatedTime = Double(imageCount) * (1 / 30) // 30 fps. @see UIImageView animationDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + estimatedTime) {
            completion?()
        }
        #endif // #if DEBUG
    }
}

private extension AnimatedLaunchScreenViewController {

    func setupHierarchy() {
        view.backgroundColor = .navy20
        view.backgroundColor = .red
        view.addSubview(backGroundImageView)
        view.addSubview(tignumImageView)
        view.addSubview(logoImageView)
        configureAnimation()
    }

    func setupLayout() {
        backGroundImageView.horizontalAnchors == view.horizontalAnchors
        backGroundImageView.verticalAnchors == view.verticalAnchors
        tignumImageView.bottomAnchor == view.bottomAnchor - 34
        tignumImageView.centerXAnchor == view.centerXAnchor
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
