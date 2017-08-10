//
//  PrepareEventTableViewFooterView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 04/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareEventTableViewFooterViewDelegate: class {

    func didTapAddNewTrip()
}

class PrepareEventTableViewFooterView: UITableViewHeaderFooterView, Dequeueable {

    @IBOutlet private weak var addNewTripButton: UIButton!
    private weak var delegate: PrepareEventTableViewFooterViewDelegate?

    func setup(title: String, delegate: PrepareEventTableViewFooterViewDelegate) {
        addNewTripButton.setTitle(title, for: .normal)
        addNewTripButton.titleLabel?.addCharactersSpacing(spacing: 1, text: title, uppercased: false)
        self.delegate = delegate
    }

    @IBAction func didTapAddNewTrip(_ sender: Any) {
        delegate?.didTapAddNewTrip()
    }
}
