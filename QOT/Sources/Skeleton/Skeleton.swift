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

    static func showLoader(backgroundColor: UIColor? = UIColor.carbon) -> UIView {
        let view = LoadingSkeleton()
        view.showLoaderSkeleton(backgroundColor: backgroundColor)
        view.tag = Skeleton.tag
        return view
    }

    static func show(_ skeletonTypes: [SkeletonType], backgroundColor: UIColor? = UIColor.carbon) -> UIView {
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
            let delay = Double(index + 3) * 0.25
            view.showSkeleton(with: type, delay: delay, backgroundColor: backgroundColor)
            stackViewSubOne.addArrangedSubview(view)
        }
        stackViewMain.addArrangedSubview(stackViewSubOne)

        let dummyView = UIView()
        dummyView.backgroundColor = backgroundColor
        stackViewMain.addArrangedSubview(dummyView)
        stackViewMain.tag = Skeleton.tag

        return stackViewMain
    }
}
