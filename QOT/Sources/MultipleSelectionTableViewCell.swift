//
//  MultipleSelectionTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 12.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol MultipleSelectionCellDelegate: class {
    func didSelectAnswer(_ answer: DTViewModel.Answer)
    func didDeSelectAnswer(_ answer: DTViewModel.Answer)
    func didSetHeight(to height: CGFloat)
}

final class MultipleSelectionTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    weak var delegate: MultipleSelectionCellDelegate?
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    private let layout = ChatViewLayout()
    private var maxPossibleSelections = 0
    private var selectionCounter = 0
    private var answers: [DTViewModel.Answer] = []

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        layout.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.registerDequeueable(MultipleSelectionCollectionViewCell.self)
    }
}

// MARK: - Configure
extension MultipleSelectionTableViewCell {
    func configure(for answers: [DTViewModel.Answer], maxPossibleSelections: Int, collectionHeight: CGFloat) {
        collectionViewHeight.constant = collectionHeight
        layoutIfNeeded()
        self.answers = answers
        self.maxPossibleSelections = maxPossibleSelections
        let selectedAnswers = answers.filter { $0.selected == true }
        selectionCounter = selectedAnswers.count
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension MultipleSelectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answers.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MultipleSelectionCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let answer = answers[indexPath.row]
        cell.configure(for: answer, maxSelections: maxPossibleSelections, selectionCounter: selectionCounter)
        cell.delegate = self
        return cell
    }
}

// MARK: - MultipleSelectionCollectionViewCellDelegate
extension MultipleSelectionTableViewCell: MultipleSelectionDelegate {
    func didDeSelectAnswer(_ answer: DTViewModel.Answer) {
        delegate?.didDeSelectAnswer(answer)
    }

    func didSelectAnswer(_ answer: DTViewModel.Answer) {
        delegate?.didSelectAnswer(answer)
    }
}

// MARK: - ChatViewLayoutDelegate
extension MultipleSelectionTableViewCell: ChatViewLayoutDelegate {
    func chatViewLayout(_ layout: ChatViewLayout, alignmentForSectionAt section: Int) -> ChatViewAlignment {
        return .right
    }

    func chatViewLayout(_ layout: ChatViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let offset = collectionView.bounds.width * 0.1
        let answerText = answers[indexPath.row].title

        let label = UILabel(frame: CGRect(center: .zero, size: CGSize(width: collectionView.bounds.width - offset, height: .AnswerButtonBig)))
        label.numberOfLines = 2
        label.attributedText = ThemeText.chatbotButton.attributedString(answerText)
        label.sizeToFit()

        let width: CGFloat = label.bounds.width
        let height: CGFloat = label.bounds.height
        return CGSize(width: width + 32, height: CGFloat(height) + 20)  //size includes constraints from cell.xib
    }

    func chatViewLayout(_ layout: ChatViewLayout, horizontalInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func chatViewLayout(_ layout: ChatViewLayout, verticalInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func chatViewLayout(_ layout: ChatViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }

    func chatViewLayout(_ layout: ChatViewLayout, sizeForHeaderAt section: Int) -> CGSize? {
        return .zero
    }

    func chatViewLayout(_ layout: ChatViewLayout, sizeForFooterAt section: Int) -> CGSize? {
        return .zero
    }

    func chatViewLayout(_ layout: ChatViewLayout, showAvatarInSection section: Int) -> Bool {
        return false
    }

    func chatViewLayout(_ layout: ChatViewLayout,
                        animatorForLayoutAttributes: UICollectionViewLayoutAttributes) -> ChatViewAnimator? {
        return nil
    }

    func chatViewLayout(_ layout: ChatViewLayout, snapToTopOffsetInSection section: Int) -> CGFloat? {
        return 0
    }

    func chatViewLayout(_ layout: ChatViewLayout, updateContentSize: CGSize) {
        delegate?.didSetHeight(to: updateContentSize.height)
    }
}
