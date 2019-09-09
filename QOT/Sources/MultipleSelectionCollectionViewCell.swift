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
    func didSelectAnswer(_ answer: ViewModel.Answer)
    func didDeSelectAnswer(_ answer: ViewModel.Answer)
}

final class MultipleSelectionCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties
    weak var delegate: MultipleSelectionCollectionViewCellDelegate?
    @IBOutlet private weak var selectionButton: SelectionButton!
    private var maxSelections = 0
    private var selectionCounter = 0
    private var answer: ViewModel.Answer?

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
    func configure(for answer: ViewModel.Answer,
                   maxSelections: Int,
                   selectionCounter: Int) {
        self.answer = answer
        self.maxSelections = maxSelections
        self.selectionCounter = selectionCounter
        selectionButton.configure(title: answer.title, isSelected: answer.selected)
    }
}

// MARK: - Actions
extension MultipleSelectionCollectionViewCell {
    @IBAction func didTapButton() {
        guard var answer = answer else { return }
        if answer.selected == true {
            delegate?.didDeSelectAnswer(answer)
            selectionButton?.switchBackgroundColor()
            answer.setSelected(false)
        } else if (selectionCounter < maxSelections) || (selectionCounter == 0 && maxSelections == 0) {
            selectionButton?.switchBackgroundColor()
            answer.setSelected(true)
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
