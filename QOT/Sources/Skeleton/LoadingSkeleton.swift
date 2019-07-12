//
//  LoadingSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class LoadingSkeleton: UIView {

    func showLoaderSkeleton() {
        loader()
    }

    func showSkeleton(with type: SkeletonType = .loader) {
        switch type {
        case .twoLinesAndButton:
            twoLinesAndButton()
        case .threeLinesAndButton:
            threeLinesAndButton()
        case .twoLinesAndImage:
            twoLinesAndImage()
        case .threeLinesAndImage:
            threeLinesAndImage()
        case .threeLines:
            threeLines()
        case .fiveLines:
            fiveLines()
        case .fiveLinesWithTopBroad:
            fiveLinesWithTopBroad()
        default:
            loader()
        }
    }
}

private extension LoadingSkeleton {

    func loader() {
        let view = Loader.instantiateFromNib()
        self.addSubview(view)
        view.addConstraints(to: self)
    }

    func twoLinesAndButton() {
        let view = TwoLinesAndButton.instantiateFromNib()
        view.startAnimating()
        self.addSubview(view)
        view.addConstraints(to: self)
    }

    func threeLinesAndButton() {
        let view = ThreeLinesAndButton.instantiateFromNib()
        view.startAnimating()
        self.addSubview(view)
        view.addConstraints(to: self)
    }

    func twoLinesAndImage() {
        let view = TwoLinesAndImage.instantiateFromNib()
        view.startAnimating()
        self.addSubview(view)
        view.addConstraints(to: self)
    }

    func threeLinesAndImage() {
        let view = ThreeLinesAndImage.instantiateFromNib()
        view.startAnimating()
        self.addSubview(view)
        view.addConstraints(to: self)
    }

    func threeLines() {
        let view = ThreeLines.instantiateFromNib()
        self.addSubview(view)
        view.addConstraints(to: self)
        self.layoutIfNeeded()
    }

    func fiveLines() {
        let view = FiveLines.instantiateFromNib()
        view.startAnimating()
        self.addSubview(view)
        view.addConstraints(to: self)
    }

    func fiveLinesWithTopBroad() {
        let view = FiveLinesWithTopBroad.instantiateFromNib()
        view.startAnimating()
        self.addSubview(view)
        view.addConstraints(to: self)
    }
}
