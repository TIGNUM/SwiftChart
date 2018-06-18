//
//  PartnerEditDeleteButtonCell.swift
//  QOT
//
//  Created by Sanggeon Park on 13.06.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnerEditDeleteButtonCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    private var interactor: PartnerEditInteractorInterface?
    private var partner: Partners.Partner?

    @IBOutlet private weak var deleteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
    }

    // MARK: - Public

    func configure(partner: Partners.Partner?, interactor: PartnerEditInteractorInterface?) {
        self.interactor = interactor
        self.partner = partner
    }
}

// MARK: - Actions

private extension PartnerEditDeleteButtonCell {

    @IBAction func didTapDeleteButton() {
        interactor?.didTapDelete(partner: self.partner)
    }
}
