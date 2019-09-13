//
//  SolveHeaderTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol SolveHeaderTableViewCellDelegate: class {
    func didTapShowMoreLess()
}

final class SolveHeaderTableViewCell: DTResultBaseTableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var solutionTextLabel: UILabel!
    @IBOutlet private weak var showMoreButton: UIButton!
    @IBOutlet private weak var constraintShowMoreHeight: NSLayoutConstraint!
    weak var delegate: SolveHeaderTableViewCellDelegate?
    private var isExpanded: Bool = false
}

// MARK: - Configuration

extension SolveHeaderTableViewCell {
    func configure(title: String, solutionText: String, hideShowMoreButton: Bool) {
        ThemeText.resultHeader1.apply(title.uppercased(), to: titleLabel)
        ThemeText.resultHeader2.apply(solutionText, to: solutionTextLabel)
        showMoreButton.isHidden = hideShowMoreButton
        constraintShowMoreHeight.constant = hideShowMoreButton ? 0.0 : 40.0
        setNeedsUpdateConstraints()
        selectionStyle = .none
    }
}

// MARK: - IBActions

extension SolveHeaderTableViewCell {
    @IBAction func didTapShowMore(_ sender: UIButton) {
        solutionTextLabel.numberOfLines = isExpanded ? 4 : 0
        showMoreButton.setTitle(isExpanded ? "Show more" : "Show less", for: .normal)
        isExpanded = !isExpanded
        delegate?.didTapShowMoreLess()
    }
}
