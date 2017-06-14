//
//  AverageMeetingView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

enum DataDisplayType: Int {
    case all = 1
    case day
    case week
    case weeks
    case month
    case year
}

class AverageMeetingView: UIView {

    private var data: MyStatisticsDataMeetingAverage
    weak var delegate: MyStatisticsCardCellDelegate?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, data: MyStatisticsDataMeetingAverage, delegate: MyStatisticsCardCellDelegate?) {
        self.data = data

        super.init(frame: frame)

        self.delegate = delegate

        setup()
    }

    private func createButton(title: String, type: DataDisplayType) -> UIButton {
        let button = UIButton()

        let color: UIColor = type == data.displayType ? .white : .white40
        let attributedTitle = Style.navigationTitle(title.uppercased(), color).attributedString(lineSpacing: 2)

        button.setAttributedTitle(attributedTitle, for: .normal)
        button.tag = type.rawValue
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        return button
    }

    private func setup() {
        let dayButton = createButton(title: R.string.localized.meSectorMyStatisticsDay(), type: .day)
        let weekButton = createButton(title: R.string.localized.meSectorMyStatisticsWeek(), type: .week)
        let separator = UIView()
        let container = UIView()

        addSubview(dayButton)
        addSubview(weekButton)
        addSubview(separator)
        addSubview(container)

        let padding: CGFloat = 8
        let separatorHeight: CGFloat = 1

        separator.backgroundColor = .white40

        dayButton.leadingAnchor == self.leadingAnchor
        dayButton.topAnchor == self.topAnchor + (padding * 2 + separatorHeight)
        dayButton.heightAnchor == 20
        dayButton.widthAnchor == self.widthAnchor / 2

        weekButton.leadingAnchor == dayButton.trailingAnchor
        weekButton.trailingAnchor == self.trailingAnchor
        weekButton.topAnchor == self.topAnchor + (padding * 2 + separatorHeight)
        weekButton.heightAnchor == dayButton.heightAnchor

        separator.topAnchor == dayButton.bottomAnchor + padding
        separator.leadingAnchor == self.leadingAnchor + padding
        separator.trailingAnchor == self.trailingAnchor - padding
        separator.heightAnchor == 1

        container.topAnchor == separator.bottomAnchor + padding
        container.leadingAnchor == self.leadingAnchor
        container.trailingAnchor == self.trailingAnchor
        container.bottomAnchor == self.bottomAnchor

        layoutIfNeeded()

        let userValue = data.userAverage() / CGFloat(data.userDays)
        let teamValue = data.teamAverage() / CGFloat(data.teamDays)
        let dataValue = data.dataAverage() / CGFloat(data.dataDays)

        let progressWheel = AverageMeetingProgressWheel(frame: container.bounds,
                                                        value: userValue,
                                                        teamValue: teamValue,
                                                        dataValue: dataValue,
                                                        pathColor: data.pathColor().color)
        container.addSubview(progressWheel)

        progressWheel.edgeAnchors == container.edgeAnchors
    }

    func didTapButton(sender: UIButton) {
        guard let type = DataDisplayType.init(rawValue: sender.tag) else { return }
        guard data.displayType != type else { return }

        data.displayType = type
        delegate?.doReload()
    }
}
