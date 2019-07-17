//
//  FromMyCoachCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 05.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FromMyCoachCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var stackView: UIStackView!

    func configure(with data: FromMyCoachCellViewModel) {
        formHeaderView(with: data.detail)
        for (index, message) in data.messages.enumerated() {
            formMessageView(isFirst: index == 0, with: message)
        }
    }

    private func formMessageView(isFirst: Bool, with data: FromMyCoachMessage) {
        guard let view = FromMyCoachMessageView.instantiateFromNib() else { return }
        view.isFirstView = isFirst
        view.configure(with: data)
        stackView.addArrangedSubview(view)
    }

    private func formHeaderView(with data: FromMyCoachDetail) {
        guard let view = FromMyCoachHeaderView.instantiateFromNib() else {
            return
        }
        view.configure(with: data)
        stackView.addArrangedSubview(view)
    }
}
