//
//  DecisionTreeQuestionnaireController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 16.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol DecisionTreeQuestionnaireDelegate: class {
    func didTapBinarySelection(_ answer: Answer)
    func didTapMultiSelection(_ answer: Answer)
    func textCellDidAppear(targetID: Int)
}

private enum CellType: Int, CaseIterable {
    case question
    case answer
}

final class DecisionTreeQuestionnaireViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: DecisionTreeQuestionnaireDelegate?
    private var selectedAnswers: [DecisionTreeModel.SelectedAnswer]
    private let extraAnswer: String?
    private let question: Question
    private let maxPossibleSelections: Int
    private lazy var tableView: UITableView = {
        return UITableView(delegate: self,
                           dataSource: self,
                           dequeables: MultipleSelectionTableViewCell.self,
                           SingleSelectionTableViewCell.self,
                           QuestionTableViewCell.self,
                           TextTableViewCell.self)
    }()

    // MARK: - Init

    init(for question: Question,
         with selectedAnswers: [DecisionTreeModel.SelectedAnswer],
         extraAnswer: String?,
         maxPossibleSelections: Int) {
        self.question = question
        self.selectedAnswers = selectedAnswers
        self.extraAnswer = extraAnswer
        self.maxPossibleSelections = maxPossibleSelections
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recalculateContentInsets()
    }
}

// MARK: - Setup

private extension DecisionTreeQuestionnaireViewController {

    func setupView() {
        attachToEdge(tableView)
        tableView.backgroundColor = .sand
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
}

// MARK: - UITableViewDelegate

extension DecisionTreeQuestionnaireViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = CellAnimator.moveUpWithBounce(rowHeight: cell.frame.height, duration: 1, delayFactor: 0.05)
        let animator = CellAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
}

// MARK: - UITableViewDataSource

extension DecisionTreeQuestionnaireViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return CellType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = CellType.allCases[indexPath.section]
        switch type {
        case .question:
            let cell: QuestionTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(with: question.title)
            return cell
        case .answer:
            switch question.answerType {
            case AnswerType.onlyExistingAnswer.rawValue:
                let cell = UITableViewCell()
                cell.backgroundColor = .sand
                delegate?.textCellDidAppear(targetID: question.answers.first?.decisions.first?.targetID ?? 0)
                return cell
            case AnswerType.yesOrNo.rawValue, AnswerType.uploadImage.rawValue:
                let cell: SingleSelectionTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(for: question, selectedAnswers: selectedAnswers)
                cell.delegate = self
                return cell
            case AnswerType.singleSelection.rawValue, AnswerType.multiSelection.rawValue:
                let cell: MultipleSelectionTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(for: Array(question.answers),
                               question: question,
                               selectedAnswers: selectedAnswers,
                               maxPossibleSelections: maxPossibleSelections)
                cell.delegate = self
                return cell
            case AnswerType.userInput.rawValue:
                return UITableViewCell()
            case AnswerType.noAnswerRequired.rawValue,
                 AnswerType.text.rawValue,
                 AnswerType.lastQuestion.rawValue:
                let cell: TextTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(with: extraAnswer ?? "")
                delegate?.textCellDidAppear(targetID: question.answers.first?.decisions.first?.targetID ?? 0)
                return cell
            default:
                preconditionFailure()
            }
        }
    }
}

// MARK: - Private

private extension DecisionTreeQuestionnaireViewController {

    func recalculateContentInsets() {
        let cellsHeight = tableView.visibleCells.map { $0.frame.height }.reduce(0, +)
        let difference = tableView.frame.height - cellsHeight
        let padding = tableView.frame.height * 0.1
        let topPadding = tableView.frame.height * 0.2
        var topInset = question.answerType != AnswerType.multiSelection.rawValue ? difference - padding : topPadding
        topInset = question.answers.count > 2 ? topInset * 0.5 : topInset
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - SingleSelectionCellDelegate

extension DecisionTreeQuestionnaireViewController: SingleSelectionCellDelegate {

    func didSelect(_ answer: Answer) {
        delegate?.didTapBinarySelection(answer)
    }
}

// MARK: - MultiselectionCellDelegate

extension DecisionTreeQuestionnaireViewController: MultipleSelectionCellDelegate {

    func didTap(_ answer: Answer) {
        delegate?.didTapMultiSelection(answer)
    }
}
