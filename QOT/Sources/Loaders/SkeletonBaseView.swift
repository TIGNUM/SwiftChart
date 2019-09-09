//
//  BaseSkeletonView.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 19/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class SkeletonBaseView: UIView {

    @IBOutlet weak var containerView: UIView!

    private let maxTags = 10

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = containerView.backgroundColor
        alpha = 0.0
    }

    func startAnimating(_ delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.doAnimation()
        }
    }

    private func doAnimation() {
        UIView.animate(withDuration: 1.0,
                       animations: {
                        self.alpha = 1.0
        }, completion: nil )

        for index in 1..<maxTags {
            if let tagView = self.viewWithTag(index) {
                UIView.animate(withDuration: 2.0,
                               delay: Double(index) * 0.25,
                               options: [.autoreverse, .repeat, .curveEaseInOut],
                               animations: {
                                tagView.alpha = 0.0
                }, completion: nil)
            }
        }
    }
}
