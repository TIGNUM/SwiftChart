//
//  PollTableViewCell.swift
//  QOT
//
//  Created by karmic on 08.09.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class PollTableViewCell: MultipleSelectionTableViewCell {

    override func chatViewLayout(_ layout: ChatViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let offset = collectionView.bounds.width * 0.1
        let answerText = answers[indexPath.row].title

        let labelSize = CGSize(width: collectionView.bounds.width - offset, height: .AnswerButtonBig)
        let label = UILabel(frame: CGRect(center: .zero, size: labelSize))
        label.numberOfLines = 2
        label.attributedText = ThemeText.chatbotButton(false).attributedString(answerText)
        label.sizeToFit()

        return CGSize(width: label.bounds.width + 66, height: label.bounds.height + 20)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PollCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let answer = answers[indexPath.row]
        cell.configure(for: answer,
                       maxSelections: maxPossibleSelections,
                       selectionCounter: selectionCounter,
                       votes: answer.votes)
        cell.delegate = self
        return cell
    }
}
