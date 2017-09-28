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

final class PrepareEventTableViewFooterView: UITableViewHeaderFooterView, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var addNewTripButton: UIButton!
    private weak var delegate: PrepareEventTableViewFooterViewDelegate?

    // MARK: - Init

    func setup(title: String, delegate: PrepareEventTableViewFooterViewDelegate) {
        addNewTripButton.setTitle(title, for: .normal)
        addNewTripButton.titleLabel?.addCharactersSpacing(spacing: 1, text: title, uppercased: false)
        self.delegate = delegate
    }
}

// MARK: - Actions

extension PrepareEventTableViewFooterView {

    @IBAction private func didTapAddNewTrip(_ sender: Any) {
        delegate?.didTapAddNewTrip()
    }
}
