//
//  MultipleSelectionCollectionViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 18.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MultipleSelectionCollectionViewCellDelegate: class {
    func didTapButton(for answer: Answer)
}

final class MultipleSelectionCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var answerButton: DecisionTreeButton!
    weak var delegate: MultipleSelectionCollectionViewCellDelegate?
    private var answer: Answer?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        answerButton.corner(radius: bounds.height * 0.25)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(syncButton(_:)),
                                               name: .multiSelectionCounter,
                                               object: nil)
    }
}

// MARK: - Configure

extension MultipleSelectionCollectionViewCell {

    func configure(for answer: Answer, isSelected: Bool) {
        self.answer = answer
        answerButton.configure(with: answer.title,
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
        delegate?.didTapButton(for: answer)
        answerButton.update()
    }
}

// MARK: - Private

private extension MultipleSelectionCollectionViewCell {

    @objc func syncButton(_ notification: Notification) {
        if
            let counter = notification.userInfo?[UserInfo.multiSelectionCounter.rawValue] as? Int,
            let selectedAnswers = notification.userInfo?[UserInfo.selectedAnswers.rawValue] as? [Answer] {
            let reachedLimit = counter == 4
            let isAlreadyAnswered = selectedAnswers.filter { $0.remoteID.value == answer?.remoteID.value }.isEmpty
            if reachedLimit == true {
                answerButton.isUserInteractionEnabled = isAlreadyAnswered == false
            }
        }
    }
}
