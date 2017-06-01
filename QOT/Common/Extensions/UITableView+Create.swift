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

    convenience init(
        style: UITableViewStyle = .plain,
        contentInsets: UIEdgeInsets = Layout.TabBarView.insets,
        backgroundColor: UIColor = .clear,
        estimatedRowHeight: CGFloat = 44,
        seperatorStyle: UITableViewCellSeparatorStyle = .none,
        delegate: UITableViewDelegate,
        dataSource: UITableViewDataSource,
        dequeables: Dequeueable.Type...) {
            self.init(frame: .zero, style: style)
            self.backgroundColor = backgroundColor
            self.estimatedRowHeight = estimatedRowHeight
            self.rowHeight = UITableViewAutomaticDimension
            self.separatorStyle = seperatorStyle
            self.contentInset = contentInsets
            self.delegate = delegate
            self.dataSource = dataSource
            self.registerDequeueables(dequeables: dequeables)
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
