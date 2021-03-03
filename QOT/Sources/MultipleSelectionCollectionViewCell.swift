//
//  MultipleSelectionCollectionViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 18.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol MultipleSelectionDelegate: class {
    func didSelectAnswer(_ answer: DTViewModel.Answer)
    func didDeSelectAnswer(_ answer: DTViewModel.Answer)
    func didSwitchSingleSelectedAnswer(_ answer: DTViewModel.Answer)
}

class MultipleSelectionCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties
    weak var delegate: MultipleSelectionDelegate?
    @IBOutlet weak var selectionButton: SelectionButton!
    private var maxSelections = 0
    private var selectionCounter = 0
    private var answer: DTViewModel.Answer?
    private var isAnswered = false
    var votes = 0

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionButton.delegate = self
        _ = NotificationCenter.default.addObserver(forName: .didUpdateSelectionCounter,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.syncButton(notification)
        }

        _ = NotificationCenter.default.addObserver(forName: .didSwitchSingleSelection,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.switchSelection(notification)
        }
    }

    // MARK: - Configure
    func configure(for answer: DTViewModel.Answer, maxSelections: Int, selectionCounter: Int) {
        self.answer = answer
        self.maxSelections = maxSelections
        self.selectionCounter = selectionCounter
        self.isAnswered = answer.selected
        selectionButton.configure(title: answer.title, isSelected: isAnswered)
    }
}

// MARK: - Actions
extension MultipleSelectionCollectionViewCell {
    @IBAction func didTapButton() {
        guard var answer = answer else { return }
        if selectionCounter == 1, maxSelections == 1, isAnswered == false {
            delegate?.didSwitchSingleSelectedAnswer(answer)
            selectAnswer(&answer)
            return
        }
        if isAnswered == true {
            deselectAnswer(&answer)
        } else if (selectionCounter < maxSelections) || (selectionCounter == .zero && maxSelections == .zero) {
            selectAnswer(&answer)
        }
    }
}

// MARK: - Private
private extension MultipleSelectionCollectionViewCell {
    @objc func syncButton(_ notification: Notification) {
        if let counter = notification.userInfo?[UserInfo.multiSelectionCounter.rawValue] as? Int {
            selectionCounter = counter > maxSelections ? .zero : counter
        }
    }

    @objc func switchSelection(_ notification: Notification) {
        if let answerRemoteId = notification.object as? Int,
           var answer = answer, answer.remoteId == answerRemoteId {
            deselectAnswer(&answer)
        }
    }

    func deselectAnswer(_ answer: inout DTViewModel.Answer) {
        answer.setSelected(false)
        isAnswered = false
        selectionButton?.switchBackgroundColor(isSelected: false)
        delegate?.didDeSelectAnswer(answer)
        NotificationCenter.default.post(name: .didUnVoteTeamTBV, object: answer.remoteId)
    }

    func selectAnswer(_ answer: inout DTViewModel.Answer) {
        let shouldMarkSelected = !(selectionCounter == .zero && maxSelections == .zero)
        answer.setSelected(shouldMarkSelected)
        isAnswered = shouldMarkSelected
        selectionButton?.switchBackgroundColor(isSelected: shouldMarkSelected)
        delegate?.didSelectAnswer(answer)
        NotificationCenter.default.post(name: .didVoteTeamTBV, object: answer.remoteId)
    }
}

// MARK: - Button Delegate
extension MultipleSelectionCollectionViewCell: AnimatedButtonDelegate {
    func willShowPressed() {
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    func willShowUnpressed() {
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}
