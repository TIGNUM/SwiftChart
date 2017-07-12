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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimating()
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

    func startAnimating() {
        logoImageView.startAnimating()
    }

    func configureAnimation() {
        let images = logoImages()
        logoImageView.image = images.last
        logoImageView.animationImages = images
        logoImageView.animationRepeatCount = 1
    }

    func logoImages() -> [UIImage] {
        var images = [UIImage?]()
        for index in 0..<92 {
            let imageName = "\(String(format: "%05d", index))_QOT_LOGO"
            images.append(UIImage(named: imageName))
        }
        return images.flatMap { $0 }
    }
}
