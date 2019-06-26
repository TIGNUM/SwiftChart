//
//  EditHeaderView.swift
//  QOT
//
//  Created by karmic on 05.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class EditHeaderView: UIView {

    weak var delegate: PrepareResultsDelegatge?

    static func instantiateFromNib() -> EditHeaderView {
        guard let resultView = R.nib.editHeaderView.instantiate(withOwner: self).first as? EditHeaderView else {
            fatalError("Cannot load audio player view")
        }
        return resultView
    }
}

private extension EditHeaderView {
    @IBAction func didPressEditButton() {
        delegate?.openEditStrategyView()
    }
}
