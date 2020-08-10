//
//  LibraryTableViewCellFactory.swift
//  QOT
//
//  Created by Sanggeon Park on 07.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

class LibraryTableViewCellFactory {
    static func cellForStorageItem(_ tableView: UITableView,
                                   _ indexPath: IndexPath,
                                   _ item: MyLibraryCellViewModel?) -> UITableViewCell {
        guard let item = item else {
            let cell = BaseMyLibraryTableViewCell()
            cell.configure()
            return cell
        }

        let cellType = item.cellType
        var returnCell: BaseMyLibraryTableViewCell?
        switch cellType {
        case .VIDEO:
            let videoCell: VideoBookmarkTableViewCell = tableView.dequeueCell(for: indexPath)
            videoCell.configure(withUrl: item.previewURL)
            returnCell = videoCell
        case .AUDIO:
            let audioCell: AudioBookmarkTableViewCell = tableView.dequeueCell(for: indexPath)
            audioCell.configure(playButtonTitle: item.duration, playButtonTag: indexPath.row)
            returnCell = audioCell
        case .ARTICLE:
            let articleCell: ArticleBookmarkTableViewCell = tableView.dequeueCell(for: indexPath)
            articleCell.configure(previewImageUrl: item.previewURL)
            returnCell = articleCell
        case .NOTE:
            let noteCell: NoteTableViewCell = tableView.dequeueCell(for: indexPath)
            noteCell.configure()
            returnCell = noteCell
        case .DOWNLOAD:
            let downloadCell: DownloadTableViewCell = tableView.dequeueCell(for: indexPath)
            downloadCell.configure()
            downloadCell.setStatus(item.downloadStatus)
            returnCell = downloadCell
        }
        returnCell?.bottomSeparator.isHidden = item.hideBottomSeparator
        returnCell?.setTitle(item.title)
        returnCell?.icon.image = item.icon
        returnCell?.setInfoText(item.description)

        return returnCell ?? UITableViewCell()
    }
}
