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
    private var baseView: QOTBaseHeaderView?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        baseView = QOTBaseHeaderView.instantiateBaseHeader(superview: self)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Configuration
    func configure(title: String, solutionText: String) {
        baseView?.configure(title: title.uppercased(), subtitle: solutionText, darkMode: false)
    }
}
