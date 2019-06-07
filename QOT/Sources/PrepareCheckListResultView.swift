//
//  PrepareCheckListResultView.swift
//  QOT
//
//  Created by karmic on 04.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareCheckListResultView: UIView {

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    weak var delegate: PrepareCheckListDelegatge?

    static func instantiateFromNib() -> PrepareCheckListResultView {
        guard let resultView = R.nib.prepareCheckListResultView.instantiate(withOwner: self).first as? PrepareCheckListResultView else {
            fatalError("Cannot load audio player view")
        }
        return resultView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        doneButton.corner(radius: 20)
    }

    func configure(text: String) {
        textLabel.text = text
    }
}

private extension PrepareCheckListResultView {
    @IBAction func didSelectDoneButton() {
        delegate?.dismissResultView()
    }
}
