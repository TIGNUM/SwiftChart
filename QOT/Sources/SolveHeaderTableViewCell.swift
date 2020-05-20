//
//  SolveHeaderTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SolveHeaderTableViewCell: DTResultBaseTableViewCell, Dequeueable {
    // MARK: - Properties
    private var baseHeaderView: QOTBaseHeaderView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        baseHeaderView = QOTBaseHeaderView.instantiateBaseHeader(superview: self)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Configuration
    func configure(title: String, solutionText: String) {
        baseHeaderView?.configure(title: title.uppercased(), subtitle: solutionText, darkMode: false)
    }
}
