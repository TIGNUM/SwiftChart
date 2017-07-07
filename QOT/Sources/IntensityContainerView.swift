//
//  ActivityContainerView.swift
//  QOT
//
//  Created by tignum on 6/21/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class IntensityContainerView: UIView {

    fileprivate var daysArray = [UILabel]()
    fileprivate var daysNames = [String]()

    fileprivate var weekButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = .white
        button.setTitle(R.string.localized.activityViewWeekButton(), for: .normal)
        button.titleLabel?.font = .bentonRegularFont(ofSize: 11)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    fileprivate var monthButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = .whiteLight
        button.titleLabel?.font = .bentonRegularFont(ofSize: 11)
        button.setTitle(R.string.localized.activityViewMonthButton(), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    func buttonPressed(_ sender: UIButton) {
        if sender == weekButton {
            monthButton.titleLabel?.textColor = .whiteLight
            weekButton.titleLabel?.textColor = .white
            gridView.duration = 16
            intensityView.columns = mockData()
            addDays(labelCount: daysNames.count)
        } else {
            monthButton.titleLabel?.textColor = .white
            weekButton.titleLabel?.textColor = .whiteLight
            gridView.duration = 30
            intensityView.columns = mockData2()
            addDays(labelCount: daysNames.count)
        }
    }

    fileprivate var stackView: UIStackView = {
        let view = UIStackView()
        view.alignment =  .fill
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()

    fileprivate var line: UIView = {
        let view = UIView()
        view.backgroundColor =  .white60
        return view
    }()

    fileprivate var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor =  .white60
        return view
    }()

    fileprivate var gridView: DottedGridWithIntensityView = {
        let view = DottedGridWithIntensityView()
        return view
    }()

    fileprivate  var intensityView: IntensityAverageView = {
        let view = IntensityAverageView()
        return view
    }()

    fileprivate  var footter: UIView = {
        let view = UIView()
        return view
    }()

    init(frame: CGRect, items: [IntensityAverageView.Column], dayNames: [String]) {
        self.daysNames = dayNames
        super.init(frame: frame)
        setupHirarchey()
        intensityView.columns = items
        gridView.setup(duration: 16)
        setupLayout()
        addBottomLine()
        addDays(labelCount: daysNames.count)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

private extension IntensityContainerView {

    func setupHirarchey() {
        addSubview(stackView)
        stackView.addArrangedSubview(weekButton)
        stackView.addArrangedSubview(monthButton)
        addSubview(gridView)
        addSubview(line)
        addSubview(intensityView)
        addSubview(footter)
    }

    func setupLayout() {
        stackView.topAnchor == self.topAnchor + 10
        stackView.horizontalAnchors == self.horizontalAnchors
        stackView.heightAnchor == 35

        line.topAnchor == stackView.bottomAnchor + 1
        line.leftAnchor == leftAnchor + 8
        line.rightAnchor == rightAnchor - 8
        line.heightAnchor == 1

        footter.heightAnchor == 12
        footter.horizontalAnchors == horizontalAnchors
        footter.bottomAnchor == bottomAnchor

        gridView.topAnchor == line.bottomAnchor
        gridView.horizontalAnchors == line.horizontalAnchors
        gridView.bottomAnchor == footter.topAnchor

        intensityView.topAnchor == line.bottomAnchor + 1
        intensityView.horizontalAnchors == line.horizontalAnchors
        intensityView.bottomAnchor == footter.topAnchor

        layoutIfNeeded()
    }

    func addBottomLine() {

        bottomLine.frame = CGRect(x: footter.bounds.minX + 5, y: footter.bounds.minY + 1, width: footter.bounds.width - 10, height: 1)
    }

    func addDays(labelCount: Int) {
        guard daysNames.count > 0 else {
            fatalError("please add daynames to uilabels")
        }
        daysArray = []
        footter.removeSubViews()
        footter.addSubview(bottomLine)
        let width = intensityView.bounds.width
        let distance: CGFloat = labelCount < 7 ? (intensityView.bounds.width / 5) : 0
        let computedWidth = width / CGFloat(labelCount)
        for index in 0..<labelCount {
            let width = CGFloat(16.2)
            let x =  distance > 0 ? CGFloat(index) * distance + distance / 2 : (CGFloat(index) * (computedWidth) + (computedWidth / 2 ))
            let frame = CGRect(x: x, y: footter.bounds.minX + 3, width: width, height: 10).integral
            daysArray.append(dayLabel(text: daysNames[index]))
            daysArray[index].frame = frame
            footter.addSubview(daysArray[index])
        }
    }

    func dayLabel(text: String) -> UILabel {
        let label = UILabel()

        label.prepareAndSetTextAttributes(text: text, font: UIFont(name: "BentonSans-Book", size: 11)!, alignment: .center)
        label.textColor = .white20

        return label
    }

    func mockData() -> [IntensityAverageView.Column] {
        let items: [IntensityAverageView.Item] = [
            IntensityAverageView.Item.init(start: 0.9, end: 0.5, color: IntensityAverageView.Color.normalColor),
            IntensityAverageView.Item.init(start: 0.0, end: 0.4, color: IntensityAverageView.Color.criticalColor)
        ]

        let column = IntensityAverageView.Column(items: items, eventWidth: 10)

        return [column, column, column, column, column, column, column]
    }

    func mockData2() -> [IntensityAverageView.Column] {
        let items: [IntensityAverageView.Item] = [
            IntensityAverageView.Item.init(start: 0.9, end: 0.5, color: IntensityAverageView.Color.normalColor),
            IntensityAverageView.Item.init(start: 0.0, end: 0.4, color: IntensityAverageView.Color.criticalColor)
        ]

        let column = IntensityAverageView.Column(items: items, eventWidth: 2.5)
        return [column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column, column]
    }
}
