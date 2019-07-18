//
//  MyToBeVisionPageComponentView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 26.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionPageComponentView: UIView {

    var stackView = UIStackView()
    private let defaultPageComponentWidth: CGFloat = 2
    private let expandedPageComponentWidth: CGFloat = 16

    var pageCount: Int = 0 {
        didSet {
            formView()
        }
    }

    var currentPageIndex = 0 {
        didSet {
            setCurrentIndex()
        }
    }

    private func formView() {
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.addConstraints(to: self)
        if pageCount == 0 { return }
        for _ in 1...pageCount {
            let view = UIView()
            view.backgroundColor = .sand
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: defaultPageComponentWidth))
            stackView.addArrangedSubview(view)
        }
    }

    private func setCurrentIndex() {
        for view in stackView.arrangedSubviews {
            view.widthConstaint?.constant = defaultPageComponentWidth
        }
        let view = stackView.arrangedSubviews[currentPageIndex]
        view.widthConstaint?.constant = expandedPageComponentWidth
        UIView.animate(withDuration: Animation.duration_01, delay: 0, animations: {
            self.layoutIfNeeded()
        })
    }
}

private extension UIView {
    var widthConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
}
