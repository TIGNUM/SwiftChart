//
//  SuggestionsHeaderView.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 19.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class SuggestionsHeaderView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Config

    func configure(title: String) {
        ThemeText.searchSuggestionHeader.apply(title, to: titleLabel)
    }

    static func instantiateFromNib() -> SuggestionsHeaderView {
        guard let view = R.nib.suggestionsHeaderView.instantiate(withOwner: self).first as? SuggestionsHeaderView else {
            fatalError("Cannot load guide view")
        }
        return view
    }
}
