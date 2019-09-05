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
    func didSelectAnswer(_ answer: QDMAnswer)
    func didDeSelectAnswer(_ answer: QDMAnswer)
}

final class MultipleSelectionTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    private var selectedAnswers: [DecisionTreeModel.SelectedAnswer] = []
    weak var delegate: MultipleSelectionCellDelegate?
    private var maxPossibleSelections: Int = 0
    private var answers: [QDMAnswer] = []
    private var question: QDMQuestion?
    private let layout = ChatViewLayout()
    private var type = DecisionTreeType.mindsetShifter

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
    func configure(for answers: [QDMAnswer],
                   question: QDMQuestion,
                   type: DecisionTreeType?,
                   selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                   maxPossibleSelections: Int) {
        self.answers = answers
        self.question = question
        self.type = type ?? .mindsetShifter
        self.selectedAnswers = selectedAnswers
        self.maxPossibleSelections = maxPossibleSelections
        collectionView.reloadData()
        collectionViewHeight.constant = layout.collectionViewContentSize.height
        collectionView.isUserInteractionEnabled = (selectedAnswers.isEmpty || selectedAnswers.count <= maxPossibleSelections)
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
        let answer: QDMAnswer = answers[indexPath.row]
        let isSelected = selectedAnswers.filter { $0.answer.remoteID == answer.remoteID }.isEmpty == false
        cell.configure(for: answer,
                       type: type,
                       isSelected: isSelected,
                       maxSelections: maxPossibleSelections,
                       selectionCounter: selectedAnswers.count)
        cell.delegate = self
        return cell
    }
}

// MARK: - MultipleSelectionCollectionViewCellDelegate
extension MultipleSelectionTableViewCell: MultipleSelectionCollectionViewCellDelegate {
    func didSelectAnswer(_ answer: QDMAnswer) {
        delegate?.didSelectAnswer(answer)
    }

    func didDeSelectAnswer(_ answer: QDMAnswer) {
        delegate?.didDeSelectAnswer(answer)
    }
}

// MARK: - ChatViewLayoutDelegate
extension MultipleSelectionTableViewCell: ChatViewLayoutDelegate {
    func chatViewLayout(_ layout: ChatViewLayout, alignmentForSectionAt section: Int) -> ChatViewAlignment {
        return .right
    }

    func chatViewLayout(_ layout: ChatViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let offset = collectionView.bounds.width * 0.1
        let buttonFont = UIFont.sfProtextSemibold(ofSize: 14)
        let answerText = answers[indexPath.row].subtitle ?? ""
        let tempWidth = answerText.size(with: buttonFont).width + offset
        let width = tempWidth <= collectionView.bounds.width ? tempWidth : collectionView.frame.width - offset
        let height = tempWidth <= collectionView.bounds.width ? CGFloat.Button.Height.AnswerButtonDefault : CGFloat.Button.Height.AnswerButtonBig
        return CGSize(width: width, height: CGFloat(height))
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
}
