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
    weak var delegate: SolveHeaderTableViewCellDelegate?
}

// MARK: - Configuration

extension SolveHeaderTableViewCell {
    func configure(title: String, solutionText: String) {
        ThemeText.resultHeader1.apply(title.uppercased(), to: titleLabel)
        ThemeText.resultHeader2.apply(solutionText, to: solutionTextLabel)
        selectionStyle = .none
    }
}
