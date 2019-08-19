//
//  BaseSkeletonView.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 19/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class BaseSkeletonView: UIView {

    @IBOutlet private weak var containerView: UIView!

    func startAnimating(_ delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.doAnimation()
        }
    }

    func doAnimation() {
        for index in 1..<10 {
            if let tagView = self.viewWithTag(index) {
                UIView.animate(withDuration: 2.0,
                               delay: Double(index) * 0.25,
                               options: [.autoreverse, .repeat, .curveEaseInOut],
                               animations: {
                                tagView.alpha = 0.0
                }, completion: { (_) in

                })
            }
        }
    }
}
