//
//  SingleSelectionTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 12.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol SingleSelectionCellDelegate: class {
    func didSelect(_ answer: QDMAnswer)
}

final class SingleSelectionTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    private var question: QDMQuestion?
    private var selectedAnswers: [DecisionTreeModel.SelectedAnswer] = []
    weak var delegate: SingleSelectionCellDelegate?
    @IBOutlet private weak var rightOptionButton: DecisionTreeButton!
    @IBOutlet private weak var leftOptionButton: DecisionTreeButton!
    @IBOutlet private weak var rightWidthContraint: NSLayoutConstraint!
    @IBOutlet private weak var leftWidthConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        rightOptionButton.cornerDefault()
        leftOptionButton.cornerDefault()
    }
}

// MARK: - Configuration
extension SingleSelectionTableViewCell {
    func configure(for question: QDMQuestion, selectedAnswers: [DecisionTreeModel.SelectedAnswer]) {
        self.question = question
        self.selectedAnswers = selectedAnswers
        let rightOption = question.answers[0]
        let leftOption = question.answers[1]
        let rightIsSelected = selectedAnswers.filter { $0.answer.remoteID == rightOption.remoteID }.count > 0
        let leftIsSelected = selectedAnswers.filter { $0.answer.remoteID == leftOption.remoteID }.count > 0
        rightOptionButton.configure(with: rightOption.subtitle ?? "",
                                    selectedBackgroundColor: rightIsSelected ? .sand : .accent30,
                                    defaultBackgroundColor: rightIsSelected ? .accent30 : .sand,
                                    borderColor: .accent30,
                                    titleColor: .accent)
        leftOptionButton.configure(with: leftOption.subtitle ?? "",
                                   selectedBackgroundColor: leftIsSelected ? .sand : .accent30,
                                   defaultBackgroundColor: leftIsSelected ? .accent30 : .sand,
                                   borderColor: .accent30,
                                   titleColor: .accent)
        rightOptionButton.isUserInteractionEnabled = (rightIsSelected || leftIsSelected) == false
        leftOptionButton.isUserInteractionEnabled = (rightIsSelected || leftIsSelected) == false
        setButtonWidth(rightButtonTtile: rightOption.subtitle, leftButtonTtile: leftOption.subtitle)
    }
}

// MARK: - Private
private extension SingleSelectionTableViewCell {
    func setButtonWidth(rightButtonTtile: String?, leftButtonTtile: String?) {
        let buttonFont = UIFont.sfProtextSemibold(ofSize: 14)
        let leftWidth = (leftButtonTtile?.size(with: buttonFont).width ?? 0) + (bounds.width * 0.1)
        let rightWidth = (rightButtonTtile?.size(with: buttonFont).width ?? 0) + (bounds.width * 0.1)
        rightWidthContraint.constant = rightWidth
        leftWidthConstraint.constant = leftWidth
    }
}

// MARK: - Actions
extension SingleSelectionTableViewCell {
    @IBAction func didTapRightOption(_ sender: UIButton) {
        if let question = question {
            delegate?.didSelect(question.answers[0])
        }
    }

    @IBAction func didTapLeftOption(_ sender: UIButton) {
        if let question = question {
            delegate?.didSelect(question.answers[1])
        }
    }
}
