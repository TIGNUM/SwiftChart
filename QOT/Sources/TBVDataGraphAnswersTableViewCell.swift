//
//  TBVDataGraphAnswersTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

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

    func configure(answer: MYTBVDataAnswer?) {
        removeAllLayers()
        setView(for: answer)
        guard let answer = answer else { return }
        let firstRate = answer.ratings.first?.value ?? 0
        let secondRate = answer.ratings.count > 1 ? answer.ratings[1].value ?? 0 : 0
        let thirdRate = answer.ratings.count > 2 ? answer.ratings[2].value ?? 0 : 0

        let isFirstSelected = answer.ratings.first?.isSelected ?? false
        let isSecondSelected = answer.ratings.count > 1  ? answer.ratings[1].isSelected : false
        let isThirdSelected = answer.ratings.count > 2 ? answer.ratings[2].isSelected : false

        let radius = thirdRatingContainerView.frame.width/2
        let badRange = NSRange(location: 1, length: 6)
        if badRange.contains(thirdRate) {
            thirdRatingContainerView?.corner(radius: radius, borderColor: .redOrange40)
        }
        if badRange.contains(secondRate) {
            secondRatingContainerView?.corner(radius: radius, borderColor: .redOrange40)
        }
        if badRange.contains(firstRate) {
            firstRatingContainerView?.corner(radius: radius, borderColor: .redOrange40)
        }

        ThemeText.tbvTrackerAnswer.apply(answer.answer, to: answerLabel)
        ThemeText.tbvTrackerRating.apply(R.string.localized.tbvTrackerLastRating(), to: lastRatingLabel)

        let theme1: ThemeText = isFirstSelected ? .tbvTrackerRatingDigitsSelected : .tbvTrackerRatingDigits
        theme1.apply(firstRate == 0 ? "-" : String(describing: firstRate), to: firstRating)

        let theme2: ThemeText = isSecondSelected ? .tbvTrackerRatingDigitsSelected : .tbvTrackerRatingDigits
        theme2.apply(secondRate == 0 ? "-" : String(describing: secondRate), to: secondRating)

        let theme3: ThemeText = isThirdSelected ? .tbvTrackerRatingDigitsSelected : .tbvTrackerRatingDigits
        theme3.apply(thirdRate == 0 ? "-" : String(describing: thirdRate), to: thirdRating)
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
