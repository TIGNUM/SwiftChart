//
//  HorizontalHeaderView.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class HorizontalHeaderView: UIView {

    @IBOutlet private weak var collectionView: UICollectionView!
    private var headerItems = [Team.Item]()

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerDequeueable(TeamHeaderCell.self)
        collectionView.setContentOffset(CGPoint(x: 24, y: 0), animated: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam,
                                               object: nil)
    }

    func configure(headerItems: [Team.Item]) {
        self.headerItems = headerItems
        collectionView.reloadData()
        centerSelectedItem()
    }
}

private extension HorizontalHeaderView {
    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if let teamId = userInfo[Team.KeyTeamId] {
            for (index, item) in headerItems.enumerated() where item.teamId == teamId {
                collectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                            at: .centeredHorizontally,
                                            animated: true)
                return
            }
        }
    }

    func centerSelectedItem() {
        for (index, item) in headerItems.enumerated() where item.selected {
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                        at: .centeredHorizontally,
                                        animated: true)
            return
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
        let item = headerItems[indexPath.row].title
        let itemSize = item.size(withAttributes: [NSAttributedString.Key.font: UIFont.sfProtextSemibold(ofSize: 14)])
        return CGSize(width: itemSize.width + .TeamHeaderOffset, height: .TeamHeader)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TeamHeaderCell = collectionView.dequeueCell(for: indexPath)
        if let item = headerItems.at(index: indexPath.row) {
            switch item.header {
            case .invite:
                cell.configure(teamInvites: item.invites)
            case .team:
                cell.configure(teamId: item.teamId,
                               title: item.title,
                               hexColorString: item.color,
                               selected: item.selected)
            }
        }
        return cell
    }
}
