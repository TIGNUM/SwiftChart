//
//  PrepareEventSelectionPresenter.swift
//  QOT
//
//  Created by karmic on 27.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareEventSelectionPresenter: PrepareEventSelectionPresenterInterface {

    // MARK: - Properties

    private weak var tableViewCell: PrepareEventSelectionTableViewCellInterface?

    // MARK: - Init

    init(tableViewCell: PrepareEventSelectionTableViewCellInterface) {
        self.tableViewCell = tableViewCell
    }
}
