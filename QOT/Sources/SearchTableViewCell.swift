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
    @IBOutlet private weak var contentTypeLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        resetLabels()
    }

    // MARK: - Public

    func configure(title: String, contentType: String?, duration: String?) {
        titleLabel.attributedText = Style.headline(title.uppercased(), .sand).attributedString()
        titleLabel.lineBreakMode = .byTruncatingTail
        if let contentType = contentType {
            contentTypeLabel.attributedText = Style.paragraph(contentType.uppercased(), .sand).attributedString()
        }
        if let duration = duration {
            durationLabel.attributedText = Style.paragraph(duration, .sand).attributedString()
        }
    }
}

// MARK: - Private

private extension SearchTableViewCell {

    func resetLabels() {
        titleLabel.text = nil
        contentTypeLabel.text = nil
        durationLabel.text = nil
    }
}
