//
//  SingleSelectionTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 12.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol SingleSelectionCellDelegate: class {
    func didSelect(_ answer: Answer)
}

final class SingleSelectionTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    private var question: Question?
    private var selectedAnswers: [DecisionTreeModel.SelectedAnswer] = []
    weak var delegate: SingleSelectionCellDelegate?
    @IBOutlet private weak var rightOptionButton: DecisionTreeButton!
    @IBOutlet private weak var leftOptionButton: DecisionTreeButton!
    @IBOutlet private weak var rightWidthContraint: NSLayoutConstraint!
    @IBOutlet private weak var leftWidthConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        rightOptionButton.corner(radius: bounds.height * 0.25)
        leftOptionButton.corner(radius: bounds.height * 0.25)
    }
}

// MARK: - Configuration

extension SingleSelectionTableViewCell {

    func configure(for question: Question, selectedAnswers: [DecisionTreeModel.SelectedAnswer]) {
        self.question = question
        self.selectedAnswers = selectedAnswers
        let rightOption = question.answers[0]
        let leftOption = question.answers[1]
        let rightIsSelected = selectedAnswers.filter { $0.answer.remoteID.value == rightOption.remoteID.value }.count > 0
        let leftIsSelected = selectedAnswers.filter { $0.answer.remoteID.value == leftOption.remoteID.value }.count > 0
        rightOptionButton.configure(with: rightOption.title,
                                    selectedBackgroundColor: rightIsSelected ? .sand : .accent30,
                                    defaultBackgroundColor: rightIsSelected ? .accent30 : .sand,
                                    borderColor: .accent30,
                                    titleColor: .accent)
        leftOptionButton.configure(with: leftOption.title,
                                   selectedBackgroundColor: leftIsSelected ? .sand : .accent30,
                                   defaultBackgroundColor: leftIsSelected ? .accent30 : .sand,
                                   borderColor: .accent30,
                                   titleColor: .accent)
        rightOptionButton.isUserInteractionEnabled = (rightIsSelected || leftIsSelected) == false
        leftOptionButton.isUserInteractionEnabled = (rightIsSelected || leftIsSelected) == false
        rightWidthContraint.constant += bounds.width * 0.05
        leftWidthConstraint.constant += bounds.width * 0.05
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
