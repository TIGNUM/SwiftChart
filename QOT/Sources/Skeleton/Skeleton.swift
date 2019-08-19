//
//  Skeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class Skeleton: UIView {
    static let tag: Int = -999

    static func showLoader() -> UIView {
        let view = LoadingSkeleton()
        view.showLoaderSkeleton()
        view.tag = Skeleton.tag
        return view
    }

    static func show(_ skeletonTypes: [SkeletonType]) -> UIView {
        let stackViewMain = UIStackView()
        stackViewMain.alignment = .fill
        stackViewMain.distribution = .fill
        stackViewMain.axis = .vertical

        let stackViewSubOne = UIStackView()
        stackViewSubOne.alignment = .fill
        stackViewSubOne.distribution = .fillProportionally
        stackViewSubOne.axis = .vertical
        for (index, type) in skeletonTypes.enumerated() {
            let view = LoadingSkeleton()
            let delay = Double(index + 1) * 0.25
            view.showSkeleton(with: type, delay: delay)
            stackViewSubOne.addArrangedSubview(view)
        }
        stackViewMain.addArrangedSubview(stackViewSubOne)

        let dummyView = UIView()
        stackViewMain.addArrangedSubview(dummyView)
        stackViewMain.tag = Skeleton.tag
        return stackViewMain
    }
}
