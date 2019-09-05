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
    weak var delegate: MultipleSelectionCollectionViewCellDelegate?
    @IBOutlet private weak var selectionButton: SelectionButton!
    private var maxSelections = 0
    private var selectionCounter = 0
    private var isAnswered = false
    private var answer: QDMAnswer?
    private var type = DecisionTreeType.mindsetShifter

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(syncButton(_:)),
                                               name: .didUpdateSelectionCounter,
                                               object: nil)
    }
}

// MARK: - Configure
extension MultipleSelectionCollectionViewCell {
    func configure(for answer: QDMAnswer,
                   type: DecisionTreeType?,
                   isSelected: Bool,
                   maxSelections: Int,
                   selectionCounter: Int) {
        self.type = type ?? .mindsetShifter
        self.answer = answer
        self.maxSelections = maxSelections
        self.isAnswered = isSelected
        self.selectionCounter = selectionCounter
        selectionButton.configure(title: answer.subtitle ?? "", isSelected: isSelected)
    }
}

// MARK: - Actions
extension MultipleSelectionCollectionViewCell {
    @IBAction func didTapButton() {
        guard let answer = answer else { return }
        if isAnswered == true {
            delegate?.didDeSelectAnswer(answer)
            if answer.canUpdateAnswerButton == true {
                selectionButton?.switchBackgroundColor()
                isAnswered = false
            }
        } else if (selectionCounter < maxSelections) || (selectionCounter == 0 && maxSelections == 0) {
            if answer.canUpdateAnswerButton == true {
                selectionButton?.switchBackgroundColor()
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
