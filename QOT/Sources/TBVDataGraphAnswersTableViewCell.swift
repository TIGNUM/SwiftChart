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

    func configure(_ sentence: QDMToBeVisionSentence, selectedDate: Date) {
        removeAllLayers()
        setupTheme(sentence)
        setupView(sentence)
        setupRatingLabels(sentence, selectedDate: selectedDate)

//        let firstRate = sentence.ratings.first?.value ?? 0
//        let secondRate = sentence.ratings.count > 1 ? sentence.ratings[1].value ?? 0 : 0
//        let thirdRate = sentence.ratings.count > 2 ? sentence.ratings[2].value ?? 0 : 0

//        let isFirstSelected = sentence.ratings.first?.isSelected ?? false
//        let isSecondSelected = sentence.ratings.count > 1  ? sentence.ratings[1].isSelected : false
//        let isThirdSelected = sentence.ratings.count > 2 ? sentence.ratings[2].isSelected : false

//
//        let isThirdLow = lowRange.contains(thirdRate)
//        let isSecondLow = lowRange.contains(secondRate)
//        let isFirstLow = lowRange.contains(firstRate)

//        if isThirdSelected {
//            self.addUnderline(for: thirdRatingContainerView, color: isThirdLow ? .redOrange : .sand)
//        }
//        if isSecondSelected {
//            self.addUnderline(for: secondRatingContainerView, color: isSecondLow ? .redOrange : .sand)
//        }
//        if isFirstSelected {
//            self.addUnderline(for: firstRatingContainerView, color: isFirstLow ? .redOrange : .sand)
//        }

    }
}

// MARK: - Private
private extension TBVDataGraphAnswersTableViewCell {
    func setupRatingLabels(_ sentence: QDMToBeVisionSentence, selectedDate: Date) {
        let lowRange = NSRange(location: 1, length: 6)
        var index = 0

        for (date, rating) in sentence.ratings {
            let isLow = lowRange.contains(rating ?? 0)
            let text = rating == nil ? "-" : String(describing: rating ?? 0)
            var theme: ThemeText = .tbvTrackerRatingDigits(isLow)

            if date == selectedDate {
                theme = .tbvTrackerRatingDigitsSelected(isLow)
                addUnderline(for: ratingContainerViews[index], color: isLow ? .redOrange : .sand)
            }

            theme.apply(text, to: ratingLabels[index])
            index += 1
        }
    }

    func setupTheme(_ sentence: QDMToBeVisionSentence) {
        ThemeText.tbvTrackerAnswer.apply(sentence.text, to: answerLabel)
        ThemeText.tbvTrackerRating.apply(R.string.localized.tbvTrackerLastRating(), to: lastRatingLabel)

//        let theme1: ThemeText = isFirstSelected ? .tbvTrackerRatingDigitsSelected(isFirstLow) : .tbvTrackerRatingDigits(isFirstLow)
//        theme1.apply(firstRate == 0 ? "-" : String(describing: firstRate), to: firstRating)
//
//        let theme2: ThemeText = isSecondSelected ? .tbvTrackerRatingDigitsSelected(isSecondLow) : .tbvTrackerRatingDigits(isSecondLow)
//        theme2.apply(secondRate == 0 ? "-" : String(describing: secondRate), to: secondRating)
//
//        let theme3: ThemeText = isThirdSelected ? .tbvTrackerRatingDigitsSelected(isThirdLow) : .tbvTrackerRatingDigits(isThirdLow)
//        theme3.apply(thirdRate == 0 ? "-" : String(describing: thirdRate), to: thirdRating)
    }

    func setupView(_ sentence: QDMToBeVisionSentence) {
        secondDot.isHidden = false
        firstDot.isHidden = false
//        secondRatingContainerView.isHidden = false
//        thirdRatingContainerView.isHidden = false
//
//        if sentence.ratings.count == 2 {
//            secondDot.isHidden = true
//            thirdRatingContainerView.isHidden = true
//        } else if sentence.ratings.count == 1 {
//            secondDot.isHidden = true
//            thirdRatingContainerView.isHidden = true
//            firstDot.isHidden = true
//            secondRatingContainerView.isHidden = true
//        }
    }

    func removeAllLayers() {
        ratingContainerViews.forEach { _ in corner(radius: 0, borderColor: .clear) }
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
