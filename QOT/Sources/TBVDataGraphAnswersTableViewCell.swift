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
    @IBOutlet private weak var firstRatingContainerView: UIView!
    @IBOutlet private weak var secondRatingContainerView: UIView!
    @IBOutlet private weak var thirdRatingContainerView: UIView!
    @IBOutlet private weak var firstRating: UILabel!
    @IBOutlet private weak var secondRating: UILabel!
    @IBOutlet private weak var thirdRating: UILabel!
    @IBOutlet weak var firstDot: UILabel!
    @IBOutlet weak var secondDot: UILabel!

    func configure(sentence: QDMToBeVisionSentence) {
        removeAllLayers()
        setView(for: answer)
        guard let answer = answer else { return }
        let firstRate = answer.ratings.first?.value ?? 0
        let secondRate = answer.ratings.count > 1 ? answer.ratings[1].value ?? 0 : 0
        let thirdRate = answer.ratings.count > 2 ? answer.ratings[2].value ?? 0 : 0

        let isFirstSelected = answer.ratings.first?.isSelected ?? false
        let isSecondSelected = answer.ratings.count > 1  ? answer.ratings[1].isSelected : false
        let isThirdSelected = answer.ratings.count > 2 ? answer.ratings[2].isSelected : false

        let lowRange = NSRange(location: 1, length: 6)
        let isThirdLow = lowRange.contains(thirdRate)
        let isSecondLow = lowRange.contains(secondRate)
        let isFirstLow = lowRange.contains(firstRate)

        if isThirdSelected {
            self.addUnderline(for: thirdRatingContainerView, color: isThirdLow ? .redOrange : .sand)
        }
        if isSecondSelected {
            self.addUnderline(for: secondRatingContainerView, color: isSecondLow ? .redOrange : .sand)
        }
        if isFirstSelected {
            self.addUnderline(for: firstRatingContainerView, color: isFirstLow ? .redOrange : .sand)
        }

        ThemeText.tbvTrackerAnswer.apply(answer.answer, to: answerLabel)
        ThemeText.tbvTrackerRating.apply(R.string.localized.tbvTrackerLastRating(), to: lastRatingLabel)

        let theme1: ThemeText = isFirstSelected ? .tbvTrackerRatingDigitsSelected(isFirstLow) : .tbvTrackerRatingDigits(isFirstLow)
        theme1.apply(firstRate == 0 ? "-" : String(describing: firstRate), to: firstRating)

        let theme2: ThemeText = isSecondSelected ? .tbvTrackerRatingDigitsSelected(isSecondLow) : .tbvTrackerRatingDigits(isSecondLow)
        theme2.apply(secondRate == 0 ? "-" : String(describing: secondRate), to: secondRating)

        let theme3: ThemeText = isThirdSelected ? .tbvTrackerRatingDigitsSelected(isThirdLow) : .tbvTrackerRatingDigits(isThirdLow)
        theme3.apply(thirdRate == 0 ? "-" : String(describing: thirdRate), to: thirdRating)
    }

    func addUnderline(for view: UIView, verticalSpacing: CGFloat = 2.0, color: UIColor = UIColor.sand) {
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

    private func setView(for answer: MYTBVDataAnswer?) {
        secondDot.isHidden = false
        firstDot.isHidden = false
        secondRatingContainerView.isHidden = false
        thirdRatingContainerView.isHidden = false

        if answer?.ratings.count == 2 {
            secondDot.isHidden = true
            thirdRatingContainerView.isHidden = true
        } else if answer?.ratings.count == 1 {
            secondDot.isHidden = true
            thirdRatingContainerView.isHidden = true
            firstDot.isHidden = true
            secondRatingContainerView.isHidden = true
        }
    }

    private func removeAllLayers() {
        thirdRatingContainerView.corner(radius: 0, borderColor: .clear)
        secondRatingContainerView.corner(radius: 0, borderColor: .clear)
        firstRatingContainerView.corner(radius: 0, borderColor: .clear)
    }
}
