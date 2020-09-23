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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(syncButton(_:)),
                                               name: .didUpdateSelectionCounter,
                                               object: nil)
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
        if isAnswered == true {
            answer.setSelected(false)
            isAnswered = false
            selectionButton?.switchBackgroundColor()
            delegate?.didDeSelectAnswer(answer)
            NotificationCenter.default.post(name: .didVoteTeamTBV, object: answer.remoteId)
        } else if (selectionCounter < maxSelections) || (selectionCounter == 0 && maxSelections == 0) {
            answer.setSelected(true)
            isAnswered = true
            selectionButton?.switchBackgroundColor()
            delegate?.didSelectAnswer(answer)
            NotificationCenter.default.post(name: .didUnVoteTeamTBV, object: answer.remoteId)
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
