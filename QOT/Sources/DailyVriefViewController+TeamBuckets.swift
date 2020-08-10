//
//  DailyVriefViewController+TeamBuckets.swift
//  QOT
//
//  Created by Sanggeon Park on 06.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

// TeamNewsFeed Related

extension DailyBriefViewController {
    func getTeamNewsFeed(_ tableView: UITableView,
                         _ indexPath: IndexPath,
                         _ viewModel: TeamNewsFeedDailyBriefViewModel?) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        switch viewModel.type {
        case .header:
            let cell: DailyBriefTeamNewsFeedHeaderCell = tableView.dequeueCell(for: indexPath)
            cell.configure(with: viewModel)
            return cell
        case .buttonAction:
            let cell: DailyBriefTeamNewsFeedFooterCell = tableView.dequeueCell(for: indexPath)
            cell.configure(with: viewModel)
            return cell
        case .storageItem:
            return LibraryTableViewCellFactory.cellForStorageItem(tableView, indexPath, viewModel.libraryCellViewModel)
        }
    }

    func handleTableViewRowSelection(with viewModel: TeamNewsFeedDailyBriefViewModel,
                                     at indexPath: IndexPath) {
        switch viewModel.type {
        case .storageItem:
            guard let storage = viewModel.feed?.teamStorage else { break }
            if storage.openStorageItem() {
                didSelectRow(at: indexPath)
            }
        default: break
        }
    }
}
