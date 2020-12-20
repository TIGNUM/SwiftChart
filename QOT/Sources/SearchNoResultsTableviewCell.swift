//
//  SearchNoResultsTableviewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20.12.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SearchNoResultsTableviewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    // MARK: - Public

    func configure(title: String) {
        ThemeText.searchNoResults.apply(title, to: titleLabel)
    }
}
