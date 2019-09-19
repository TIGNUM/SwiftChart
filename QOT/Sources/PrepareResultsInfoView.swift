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
    weak var delegate: PrepareResultsDelegatge?

    static func instantiateFromNib() -> PrepareResultsInfoView {
        guard let resultView = R.nib.prepareResultsInfoView.instantiate(withOwner: self)
            .first as? PrepareResultsInfoView else {
            fatalError("Cannot load PrepareResultsInfoView")
        }
        return resultView
    }

    func configure(text: String) {
        textLabel.text = text
    }
}

private extension PrepareResultsInfoView {
    @IBAction func didSelectDoneButton() {
        delegate?.dismissResultView()
    }
}
