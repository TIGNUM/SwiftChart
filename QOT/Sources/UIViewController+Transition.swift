//
//  UIViewController+Transition.swift
//  QOT
//
//  Created by karmic on 24.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

internal final class FakePresentedViewController: UIViewController, ScreenZLevelIgnore {
    var isShown = false
    var bgImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: bgImage)
        view.fill(subview: imageView)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isShown {
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }
        } else {
            isShown = true
        }
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return []
    }
}

extension UIViewController {

    func presentRightToLeft(controller: UIViewController) {
        let bgImage = captureScreenshot()
        let emptyVC = FakePresentedViewController()
        emptyVC.bgImage = bgImage
        emptyVC.view.backgroundColor = .clear
        let naviController = UINavigationController(rootViewController: emptyVC)
        naviController.isToolbarHidden = true
        naviController.isNavigationBarHidden = true
        naviController.modalPresentationStyle = .fullScreen
        naviController.modalPresentationCapturesStatusBarAppearance = false

        self.present(naviController, animated: false, completion: {
            naviController.pushViewController(controller, animated: true)
        })
    }

    private func captureScreenshot() -> UIImage? {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }
}
