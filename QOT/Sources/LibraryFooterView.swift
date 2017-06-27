//
//  LibraryFooterView.swift
//  QOT
//
//  Created by karmic on 27.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LibraryFooterView: UIView {

    @IBOutlet fileprivate weak var footerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        footerLabel.attributedText = Style.headlineSmall(R.string.localized.libraryFooterViewLabel().uppercased(), .white40).attributedString()
        backgroundColor = .clear
    }
}
