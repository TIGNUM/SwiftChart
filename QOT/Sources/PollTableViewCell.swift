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

        let label = UILabel(frame: CGRect(center: .zero, size: CGSize(width: collectionView.bounds.width - offset, height: .AnswerButtonBig)))
        label.numberOfLines = 2
        label.attributedText = ThemeText.chatbotButton.attributedString(answerText)
        label.sizeToFit()

        let width: CGFloat = label.bounds.width
        let height: CGFloat = label.bounds.height
        return CGSize(width: width + 66, height: CGFloat(height) + 20)  //size includes constraints from cell.xib
    }
}
