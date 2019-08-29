//
//  SearchTableViewCell.swift
//  QOT
//
//  Created by karmic on 09.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SearchTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var durationLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        resetLabels()
    }

    // MARK: - Public

    func configure(title: String, contentType: Search.DisplayType?, duration: String?) {
        ThemeText.searchResult.apply(title.uppercased(), to: titleLabel)
        if let contentType = contentType {
            iconImage.image = contentType.mediaIcon()
        }
        if let duration = duration {
            ThemeText.datestamp.apply(duration, to: durationLabel)
        }
    }
}

// MARK: - Private

private extension SearchTableViewCell {

    func resetLabels() {
        titleLabel.text = nil
        iconImage.image = nil
        durationLabel.text = nil
    }
}
