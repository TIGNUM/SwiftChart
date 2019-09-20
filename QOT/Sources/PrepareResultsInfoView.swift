//
//  PrepareResultsInfoView.swift
//  QOT
//
//  Created by karmic on 04.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareResultsInfoView: UIView {

    @IBOutlet private weak var textLabel: UILabel!

    static func instantiateFromNib() -> PrepareResultsInfoView {
        guard let resultView = R.nib.prepareResultsInfoView.instantiate(withOwner: self)
            .first as? PrepareResultsInfoView else {
            fatalError("Cannot load PrepareResultsInfoView")
        }
        return resultView
    }

    func configure(text: String) {
        ThemeText.resultClosingText.apply(text, to: textLabel)
        ThemeView.chatbot.apply(self)
        textLabel.text = text
    }
}
