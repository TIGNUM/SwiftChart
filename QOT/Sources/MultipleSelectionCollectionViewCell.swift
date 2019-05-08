//
//  MultipleSelectionCollectionViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 18.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MultipleSelectionCollectionViewCellDelegate: class {
    func didTapButton(at indexPath: IndexPath)
}

final class MultipleSelectionCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var answerButton: DecisionTreeButton!
    private var indexPath = IndexPath(row: 0, section: 0)
    weak var delegate: MultipleSelectionCollectionViewCellDelegate?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        answerButton.corner(radius: bounds.height * 0.25)
    }
}

// MARK: - Configure

extension MultipleSelectionCollectionViewCell {

    func configure(with title: String, at indexPath: IndexPath, isSelected: Bool) {
        self.indexPath = indexPath
        answerButton.configure(with: title,
                               selectedBackgroundColor: isSelected ? .sand : .accent30,
                               defaultBackgroundColor: isSelected ? .accent30 : .sand,
                               borderColor: .accent30,
                               titleColor: .accent)
    }
}

// MARK: - Actions

extension MultipleSelectionCollectionViewCell {

    @IBAction func didTapButton(_ sender: DecisionTreeButton) {
        delegate?.didTapButton(at: indexPath)
        answerButton.update()
    }
}
