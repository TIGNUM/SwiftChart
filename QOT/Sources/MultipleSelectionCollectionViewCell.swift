//
//  MultipleSelectionCollectionViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 18.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol MultipleSelectionCollectionViewCellDelegate: class {
    func didSelectAnswer(_ answer: QDMAnswer)
    func didDeSelectAnswer(_ answer: QDMAnswer)
}

final class MultipleSelectionCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var answerButton: DecisionTreeButton!
    weak var delegate: MultipleSelectionCollectionViewCellDelegate?
    private var maxSelections = 0
    private var selectionCounter = 0
    private var isAnswered = false
    private var answer: QDMAnswer?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        answerButton.cornerDefault()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(syncButton(_:)),
                                               name: .didUpdateSelectionCounter,
                                               object: nil)
    }
}

// MARK: - Configure
extension MultipleSelectionCollectionViewCell {
    func configure(for answer: QDMAnswer,
                   isSelected: Bool,
                   maxSelections: Int,
                   selectionCounter: Int,
                   answerButtonNeedsUpdate: Bool) {
        self.answer = answer
        self.maxSelections = maxSelections
        self.isAnswered = isSelected
        self.selectionCounter = selectionCounter
        answerButton.configure(with: answer.subtitle ?? "",
                               selectedBackgroundColor: isSelected ? .clear : .accent30,
                               defaultBackgroundColor: isSelected ? .accent30 : .clear,
                               borderColor: .accent30,
                               titleColor: .accent)
        if answerButtonNeedsUpdate {
            answerButton.titleLabel?.lineBreakMode = .byWordWrapping
            answerButton.titleLabel?.numberOfLines = 2
            answerButton.sizeToFit()
        }
    }
}

// MARK: - Actions
extension MultipleSelectionCollectionViewCell {
    @IBAction func didTapButton(_ sender: DecisionTreeButton) {
        guard let answer = answer else { return }
        if isAnswered == true {
            delegate?.didDeSelectAnswer(answer)
            if answer.canUpdateAnswerButton == true {
                answerButton.update()
                isAnswered = false
            }
        } else if (selectionCounter < maxSelections) || (selectionCounter == 0 && maxSelections == 0) {
            if answer.canUpdateAnswerButton == true {
                answerButton.update()
                isAnswered = true
            }
            delegate?.didSelectAnswer(answer)
        }
    }
}

// MARK: - Private
private extension MultipleSelectionCollectionViewCell {
    @objc func syncButton(_ notification: Notification) {
        if let counter = notification.userInfo?[UserInfo.multiSelectionCounter.rawValue] as? Int {
            selectionCounter = counter > maxSelections ? 0 : counter
        }
    }
}
