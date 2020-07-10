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
    private var headerItems = [TeamHeader.Item]()

    func configure(headerItems: [TeamHeader.Item]) {
        self.headerItems = headerItems
        collectionView.reloadData()
    }
}

extension HorizontalHeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerItems.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let offset = collectionView.bounds.width * 0.1
        let answerText = headerItems.at(index: indexPath.row)?.title
        let label = UILabel(frame: CGRect(center: .zero,
                                          size: CGSize(width: collectionView.bounds.width - offset,
                                                       height: .TeamHeader)))
        label.numberOfLines = 1
        label.attributedText = ThemeText.chatbotButton.attributedString(answerText)
        label.sizeToFit()
        let width: CGFloat = label.bounds.width
        return CGSize(width: width + 32, height: .TeamHeader)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = R.reuseIdentifier.teamHeaderCell_ID.identifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                            for: indexPath) as? TeamHeaderCell else {
                                                                fatalError("TeamHeaderCell not valid")
        }
        if let item = headerItems.at(index: indexPath.row) {
            if let invite = item.inviteButton {
                cell.configure(title: invite.title, counter: invite.counter)
            } else {
                cell.configure(teamId: item.teamId,
                               title: item.title,
                               hexColorString: item.hexColorString,
                               selected: item.selected)

            }
        }
        return cell
    }
}
