//
//  PollCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 07.09.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class PollCollectionViewCell: MultipleSelectionCollectionViewCell {

    // MARK: - Properties
    @IBOutlet private weak var pollButton: PollButton!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        pollButton.counterLabel.circle()
    }

    // MARK: - Configure
    func configure(for answer: DTViewModel.Answer, maxSelections: Int, selectionCounter: Int, votes: Int) {
        super.configure(for: answer, maxSelections: maxSelections, selectionCounter: selectionCounter)
        pollButton.configure(title: answer.title, votes: votes, isSelected: answer.selected)
    }
}
