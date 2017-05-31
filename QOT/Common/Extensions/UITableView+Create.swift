//
//  UITableView+Create.swift
//  QOT
//
//  Created by karmic on 31.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    static func setup(
        style: UITableViewStyle = .plain,
        contentInsets: UIEdgeInsets = Layout.TabBarView.insets,
        backgroundColor: UIColor = .clear,
        estimatedRowHeight: CGFloat = 44,
        seperatorStyle: UITableViewCellSeparatorStyle = .none,
        delegate: UITableViewDelegate,
        dataSource: UITableViewDataSource,
        dequeables: Dequeueable.Type...) -> UITableView {

            let tableView = UITableView(frame: .zero, style: style)
            tableView.backgroundColor = backgroundColor
            tableView.estimatedRowHeight = estimatedRowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.separatorStyle = seperatorStyle
            tableView.contentInset = contentInsets
            tableView.delegate = delegate
            tableView.dataSource = dataSource
            tableView.registerDequeueables(dequeables: dequeables)

            return tableView
    }

    private func registerDequeueables(dequeables: [Dequeueable.Type]) {
        dequeables.forEach { (type) in
            switch type.registration {
            case .nib(let nib):
                register(nib, forCellReuseIdentifier: type.reuseID)
            case .class:
                register(type, forCellReuseIdentifier: type.reuseID)
            }
        }
    }
}
