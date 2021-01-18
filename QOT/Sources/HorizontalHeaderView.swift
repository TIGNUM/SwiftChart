//
//  HorizontalHeaderView.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class HorizontalHeaderView: UIView {

    @IBOutlet private weak var collectionView: UICollectionView!
    private var headerItems = [Team.Item]()
    private var canDeselect = true
    static var selectedTeamId = Team.Header.myX.inviteId
    static var setMyX = true

    override func awakeFromNib() {
        super.awakeFromNib()
        log("⏰💤", level: .debug)
        collectionView.registerDequeueable(TeamHeaderCell.self)
        _ = NotificationCenter.default.addObserver(forName: .didSelectTeam,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.checkSelection(notification)
        }

        _ = NotificationCenter.default.addObserver(forName: .didSelectMyX,
                                                   object: nil,
                                                   queue: .main) { [weak self] _ in
            self?.scrollToItem(index: 0)
        }
    }

    func configure(headerItems: [Team.Item], canDeselect: Bool = true) {
        self.headerItems = headerItems
        self.canDeselect = canDeselect
        collectionView.reloadData()
        centerSelectedItem()
    }
}

private extension HorizontalHeaderView {
    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if let teamId = userInfo[Team.KeyTeamId] {
            if canDeselect {
                HorizontalHeaderView.selectedTeamId = teamId == HorizontalHeaderView.selectedTeamId ? "" : teamId
            } else {
                HorizontalHeaderView.selectedTeamId = teamId
            }
            for (index, item) in headerItems.enumerated() where item.teamId == teamId {
                scrollToItem(index: index)
                break
            }
            log("HorizontalHeaderView.selectedTeamId: ➡️➡️➡️➡️➡️➡️✅" + HorizontalHeaderView.selectedTeamId,
                level: .debug)
            log("userInfo.teamId: ➡️➡️➡️➡️➡️➡️✅" + teamId, level: .debug)
        }
    }

    func centerSelectedItem() {
        guard collectionView.contentSize.width > collectionView.frame.size.width else { return }
        for (index, item) in headerItems.enumerated() where item.isSelected {
            scrollToItem(index: index)
            return
        }
    }

    func scrollToItem(index: Int) {
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
        if index == 0 || headerItems.endIndex == index {
            collectionView.setContentOffset(CGPoint(x: -16, y: 0), animated: true)
        }
    }
}

extension HorizontalHeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerItems.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = headerItems[indexPath.row].title
        let itemSize = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.sfProtextSemibold(ofSize: 14)])
        return CGSize(width: itemSize.width + .TeamHeaderOffset, height: .TeamHeader)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TeamHeaderCell = collectionView.dequeueCell(for: indexPath)
        if let item = headerItems.at(index: indexPath.row) {
            switch item.header {
            case .myX:
                cell.configure(teamId: item.teamId,
                               title: item.title,
                               hexColorString: item.color,
                               selected: item.isSelected,
                               canDeselect: canDeselect,
                               newCount: item.batchCount)
            case .invite:
                cell.configure(teamInvites: item.invites)
            case .team:
                cell.configure(teamId: item.teamId,
                               title: item.title,
                               hexColorString: item.color,
                               selected: item.isSelected,
                               canDeselect: canDeselect,
                               newCount: item.batchCount)
            }
        }
        return cell
    }
}
