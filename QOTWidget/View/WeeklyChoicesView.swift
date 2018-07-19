//
//  WeeklyChoicesView.swift
//  QOTWidget
//
//  Created by Javier Sanz Rozalen on 05/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol WeeklyChoicesViewDelegate: class {
    func didTapSetYourWeeklyChoices(in view: UIView)
}

final class WeeklyChoicesView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var weeklyChoicesLabel: UILabel!
    @IBOutlet private weak var setWeeklyChoicesButton: UIButton!
    weak var delegate: WeeklyChoicesViewDelegate?
	var height: CGFloat {
        return setWeeklyChoicesButton.isHidden == true ? 140 : 170
	}

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
	
    // MARK: - Actions

	func configure(weeklyChoices: WidgetModel.WeeklyChoices) {
		if let choices = weeklyChoices.latestWeeklyChoices, choices.count > 0 {
			var text = ""
			choices.forEach { text += "· \($0.count > 35 ? $0.prefix(35) + "..." : $0)\n" }
			weeklyChoicesLabel.text = text.capitalized
			return
		}
		weeklyChoicesLabel.text = "You have not yet set any weekly choices."
        setWeeklyChoicesButton.isHidden = false
	}

    @IBAction func didTapSetWeeklyChoices(_ sender: UIButton) {
        delegate?.didTapSetYourWeeklyChoices(in: self)
    }
}

// MARK: - Private

extension WeeklyChoicesView {

    func setupView() {
        weeklyChoicesLabel.textColor = .gray
        setWeeklyChoicesButton.isHidden = true
        setWeeklyChoicesButton.layer.cornerRadius = 6
    }
}
