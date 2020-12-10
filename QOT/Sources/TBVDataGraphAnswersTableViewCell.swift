//
//  TBVDataGraphAnswersTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TBVDataGraphAnswersTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var lastRatingLabel: UILabel!
    @IBOutlet private weak var firstDot: UILabel!
    @IBOutlet private weak var secondDot: UILabel!
    @IBOutlet private var ratingLabels: [UILabel]!
    @IBOutlet private var ratingContainerViews: [UIView]!

    func configure(_ sentence: QDMToBeVisionSentence, selectedDate: Date, isTeam: Bool) {
        removeAllLayers()
        setupTheme(sentence, isTeam: isTeam)
        setupView(sentence)
        setupRatingLabels(sentence, selectedDate: selectedDate)
    }
}

// MARK: - Private
private extension TBVDataGraphAnswersTableViewCell {
    func setupRatingLabels(_ sentence: QDMToBeVisionSentence, selectedDate: Date) {
        let lowRange = NSRange(location: 1, length: 6)
        let sortedDict = sentence.last3Ratings.sorted(by: { $0.key < $1.key })
        var index = 0

        for (date, rating) in sortedDict where !rating.isNaN {
            let isLow = lowRange.contains(Int(rating))
            let text = rating <= 0 ? "-" : String(describing: rating)
            var theme: ThemeText = .tbvTrackerRatingDigits(isLow)

            if date == selectedDate {
                theme = .tbvTrackerRatingDigitsSelected(isLow)
                addUnderline(for: ratingContainerViews[index], color: isLow ? .redOrange : .sand)
            }

            theme.apply(text, to: ratingLabels[index])
            index += 1
        }
    }

    func setupTheme(_ sentence: QDMToBeVisionSentence, isTeam: Bool) {
        ThemeText.tbvTrackerAnswerTeam.apply(sentence.text, to: answerLabel)
        ThemeText.tbvTrackerRating.apply(AppTextService.get(isTeam ? .my_x_team_vision_tracker_average_rating :
                                                                .my_qot_my_tbv_tbv_tracker_data_section_my_tbv_label_last_ratings),
            to: lastRatingLabel)
    }

    func setupView(_ sentence: QDMToBeVisionSentence) {
        secondDot.isHidden = false
        firstDot.isHidden = false
        ratingContainerViews[1].isHidden = false
        ratingContainerViews[2].isHidden = false

        if sentence.last3Ratings.count == 2 {
            secondDot.isHidden = true
            ratingContainerViews[2].isHidden = true
        } else if sentence.last3Ratings.count == 1 {
            secondDot.isHidden = true
            ratingContainerViews[2].isHidden = true
            firstDot.isHidden = true
            ratingContainerViews[1].isHidden = true
        }
    }

    func removeAllLayers() {
        ratingContainerViews.forEach { (ratingView) in
            ratingView.corner(radius: 0, borderColor: .clear)
        }
    }

    func addUnderline(for view: UIView, verticalSpacing: CGFloat = 2.0, color: UIColor = .sand) {
        let lineLayer = CALayer()
        let sideOffset: CGFloat = 4.0
        lineLayer.backgroundColor = color.cgColor
        lineLayer.frame = CGRect(x: sideOffset,
                                 y: view.bounds.height + verticalSpacing,
                                 width: view.bounds.width - 2 * sideOffset,
                                 height: 1)
        view.clipsToBounds = false
        view.layer.addSublayer(lineLayer)
    }
}
