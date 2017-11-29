//
//  PageControl.swift
//  QOT
//
//  Created by karmic on 10.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class PageControl: UIPageControl {

    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }

    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        pageIndicatorTintColor = .clear
        currentPageIndicatorTintColor = .clear
        clipsToBounds = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension PageControl {

    func updateDots() {
        for (index, view) in subviews.enumerated() {
            var imageView = iamgeViewForSubview(view: view)
            if imageView == nil {
                imageView = createDot(index: index, subView: view)
            }

            imageView?.image = index == currentPage ? R.image.pageControlSelected() : R.image.pageControlUnSelected()
        }
    }

    func createDot(index: Index, subView: UIView) -> UIImageView? {
        let imageView = index == currentPage ? UIImageView(image: R.image.pageControlSelected()) : UIImageView(image: R.image.pageControlUnSelected())
        imageView.center = subView.center
        subView.addSubview(imageView)
        subView.clipsToBounds = false

        return imageView
    }

    func iamgeViewForSubview(view: UIView) -> UIImageView? {
        var dot: UIImageView?

        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    return imageView
                }
            }
        }

        return dot
    }
}
