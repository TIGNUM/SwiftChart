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
    func configure(for answer: QDMAnswer, isSelected: Bool, maxSelections: Int) {
        self.answer = answer
        self.maxSelections = maxSelections
        self.isAnswered = isSelected
        self.selectionCounter = 0
        answerButton.configure(with: answer.subtitle ?? "",
                               selectedBackgroundColor: isSelected ? .sand : .accent30,
                               defaultBackgroundColor: isSelected ? .accent30 : .sand,
                               borderColor: .accent30,
                               titleColor: .accent)
    }
}

// MARK: - Actions
extension MultipleSelectionCollectionViewCell {
    @IBAction func didTapButton(_ sender: DecisionTreeButton) {
        guard let answer = answer else { return }
        if isAnswered == true {
            delegate?.didDeSelectAnswer(answer)
            answerButton.update()
            isAnswered = false
        } else if selectionCounter < maxSelections {
            answerButton.update()
            isAnswered = true
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
