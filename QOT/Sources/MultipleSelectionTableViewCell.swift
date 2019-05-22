//
//  MultipleSelectionTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 12.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MultipleSelectionCellDelegate: class {
    func didTap(_ answer: Answer)
}

final class MultipleSelectionTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    private var selectedAnswers: [DecisionTreeModel.SelectedAnswer] = []
    weak var delegate: MultipleSelectionCellDelegate?
    private var maxPossibleSelections: Int = 0
    private var answers: [Answer] = []
    private var question: Question?
    private let layout = ChatViewLayout()

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

    func configure(for answers: [Answer],
                   question: Question,
                   selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                   maxPossibleSelections: Int) {
        self.answers = answers
        self.question = question
        self.selectedAnswers = selectedAnswers
        self.maxPossibleSelections = maxPossibleSelections
        collectionView.reloadData()
        collectionViewHeight.constant = layout.collectionViewContentSize.height
        collectionView.isUserInteractionEnabled = (selectedAnswers.isEmpty || selectedAnswers.count < maxPossibleSelections)
        layoutIfNeeded()
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
        let answer: Answer = answers[indexPath.row]
        let isSelected = selectedAnswers.filter { $0.answer.remoteID.value == answer.remoteID.value }.isEmpty == false
        cell.configure(for: answer, isSelected: isSelected, maxPossibleSelections: maxPossibleSelections)
        cell.delegate = self
        return cell
    }
}

// MARK: - MultipleSelectionCollectionViewCellDelegate

extension MultipleSelectionTableViewCell: MultipleSelectionCollectionViewCellDelegate {

    func didTapButton(for answer: Answer) {
        if selectedAnswers.count < maxPossibleSelections {
            delegate?.didTap(answer)
        }
    }
}

// MARK: - ChatViewLayoutDelegate

extension MultipleSelectionTableViewCell: ChatViewLayoutDelegate {

    func chatViewLayout(_ layout: ChatViewLayout, alignmentForSectionAt section: Int) -> ChatViewAlignment {
        return .right
    }

    func chatViewLayout(_ layout: ChatViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonFont = UIFont.systemFont(ofSize: 12)
        let width = answers[indexPath.row].title.size(with: buttonFont).width + collectionView.bounds.width * 0.1
        return CGSize(width: width, height: 40)
    }

    func chatViewLayout(_ layout: ChatViewLayout, horizontalInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func chatViewLayout(_ layout: ChatViewLayout, verticalInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func chatViewLayout(_ layout: ChatViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
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
