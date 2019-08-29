//
//  SuggestionSearchTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 18.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SuggestionSearchTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var suggestionLabel: UILabel!

    // MARK: - Configuration

    func configrue(suggestion: String) {
        ThemeText.searchSuggestion.apply(suggestion.uppercased(), to: suggestionLabel)
    }
}
