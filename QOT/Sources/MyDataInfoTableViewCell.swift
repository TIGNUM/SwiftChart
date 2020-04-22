//
//  MyDataInfoTableViewCell.swift
//  QOT
//
//  Created by Voicu on 20.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyDataInfoTableViewCellDelegate: class {
    func didTapInfoButton(sender: MyDataInfoTableViewCell)
}

final class MyDataInfoTableViewCell: UITableViewCell, Dequeueable {
    // MARK: - Properties
    weak var delegate: MyDataInfoTableViewCellDelegate?
    private var baseHeaderView: QOTBaseHeaderView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        baseHeaderView = QOTBaseHeaderView.instantiateBaseHeader(superview: self)
        baseHeaderView?.subtitleTextView.isSelectable = true
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(title: String?, subtitle: String?) {
        guard let title = title, let subtitle = subtitle, let baseHeaderView = baseHeaderView else {
            return
        }
        baseHeaderView.configure(title: title, subtitle: subtitle)
    }
}
