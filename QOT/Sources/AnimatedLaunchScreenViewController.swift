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

    fileprivate var backGroundImageView: UIImageView = UIImageView(image: R.image._1_1Learn())
    fileprivate var logoImageView: UIImageView = UIImageView()
    fileprivate let imageCount = 92

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func fadeInLogo(withCompletion completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 2.0, animations: {
            self.logoImageView.alpha = 1.0
        }, completion: { (_: Bool) in
            completion?()
        })
    }
    
    func fadeOutLogo(withCompletion completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.logoImageView.alpha = 0.0
        }, completion: { (_: Bool) in
            completion?()
        })
    }
    
    func startAnimatingImages(withCompletion completion: (() -> Void)? = nil) {
        logoImageView.startAnimating()
        
        let estimatedTime = Double(imageCount) * (1.0 / 30.0) // 30 fps. @see UIImageView animationDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + estimatedTime) {
            completion?()
        }
    }
}

private extension AnimatedLaunchScreenViewController {
    func setupHierarchy() {
        view.backgroundColor = .navy20
        view.backgroundColor = .red
        view.addSubview(backGroundImageView)
        view.addSubview(logoImageView)
        configureAnimation()
    }

    func setupLayout() {
        backGroundImageView.horizontalAnchors == view.horizontalAnchors
        backGroundImageView.verticalAnchors == view.verticalAnchors

        logoImageView.heightAnchor == 48
        logoImageView.widthAnchor == 138
        logoImageView.centerAnchors == view.centerAnchors

        view.layoutIfNeeded()
    }

    func configureAnimation() {
        let images = logoImages()
        logoImageView.alpha = 0.0
        logoImageView.image = images.last
        logoImageView.animationImages = images
        logoImageView.animationRepeatCount = 1
    }

    func logoImages() -> [UIImage] {
        var images = [UIImage?]()
        for index in 0..<imageCount {
            let imageName = "anim_\(String(format: "%05d", index))_QOT_LOGO"
            images.append(UIImage(named: imageName))
        }
        return images.flatMap { $0 }
    }
}
