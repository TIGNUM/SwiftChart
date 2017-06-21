//
//  ContainerView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/15/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class ContainerView: UIView {

    fileprivate var daysArray = [UILabel]()
    fileprivate var dayNames = [String]()
    fileprivate var eventView: EventGraphView = {
        let view = EventGraphView()
        return view
    }()

    fileprivate var bottomView: UIView = {
        let view = UIView()
        return view
    }()

    fileprivate var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white8
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
        addBottomLine()
        addDays()
    }

    func setup(columns: [EventGraphView.Column], dayNames: [String]) {
        addViews()
        eventView.columns = columns
        self.dayNames = dayNames
    }

}

private extension ContainerView {

    func addViews() {
        addSubview(eventView)
        addSubview(bottomView)
        bottomView.addSubview(bottomLine)
    }

    func setupLayout() {
        let padding: CGFloat = 8
        let separatorHeight: CGFloat = 1

        eventView.topAnchor == topAnchor + padding + separatorHeight
        eventView.horizontalAnchors == horizontalAnchors
        eventView.bottomAnchor == bottomView.topAnchor

        bottomView.heightAnchor == 16
        bottomView.horizontalAnchors == horizontalAnchors
        bottomView.bottomAnchor == bottomAnchor

        layoutIfNeeded()
    }

    func addBottomLine() {

        bottomLine.frame = CGRect(x: bottomView.bounds.minX + 5, y: bottomView.bounds.minY - 1, width: bottomView.bounds.width - 10, height: 1)
    }

    func addDays() {
        let width = eventView.bounds.width
        let computedWidth = width / CGFloat(eventView.columns.count)
        for index in 0..<eventView.columns.count {
            let width = CGFloat(16.2)
            let frame = CGRect(x: computedWidth * CGFloat(index) + width / 2, y: bottomView.bounds.minX + 3, width: width, height: 10)
            daysArray.append(dayLabel(text: dayNames[index]))
            daysArray[index].frame = CGRect(x: frame.midX, y: frame.minY, width: frame.width, height: frame.height)
            bottomView.addSubview(daysArray[index])
        }
    }

    func dayLabel(text: String) -> UILabel {
        let label = UILabel()

        label.prepareAndSetTextAttributes(text: text, font: UIFont(name: "BentonSans-Book", size: 11)!, alignment: .center)
        label.textColor = .white20

        return label
    }

}
