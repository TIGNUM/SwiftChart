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
    func didSelect(_ answer: DTViewModel.Answer)
}

final class SingleSelectionTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    weak var delegate: SingleSelectionCellDelegate?
    private var rightAnswer: DTViewModel.Answer?
    private var leftAnswer: DTViewModel.Answer?
    @IBOutlet private weak var rightOptionButton: AnswerButton!
    @IBOutlet private weak var leftOptionButton: AnswerButton!
}

// MARK: - Configuration
extension SingleSelectionTableViewCell {
    func configure(for rightAnswer: DTViewModel.Answer?, leftAnswer: DTViewModel.Answer?) {
        guard let rightAnswer = rightAnswer, let leftAnswer = leftAnswer else { return }
        rightOptionButton.configure(title: rightAnswer.title, isSelected: rightAnswer.selected)
        leftOptionButton.configure(title: leftAnswer.title, isSelected: leftAnswer.selected)
        rightOptionButton.isUserInteractionEnabled = (rightAnswer.selected || leftAnswer.selected) == false
        leftOptionButton.isUserInteractionEnabled = (rightAnswer.selected || leftAnswer.selected) == false
        rightOptionButton.backgroundColor = rightAnswer.backgroundColor
        leftOptionButton.backgroundColor = leftAnswer.backgroundColor
        self.rightAnswer = rightAnswer
        self.leftAnswer = leftAnswer
    }
}

// MARK: - Actions
extension SingleSelectionTableViewCell {
    @IBAction func didTapRightOption() {
        if var answer = rightAnswer {
            answer.setSelected(true)
            delegate?.didSelect(answer)
        }
    }

    @IBAction func didTapLeftOption() {
        if var answer = leftAnswer {
            answer.setSelected(true)
            delegate?.didSelect(answer)
        }
    }
}
