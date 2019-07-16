//
//  DecisionTreeQuestionnaireController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 16.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DecisionTreeQuestionnaireDelegate: class {
    func didTapBinarySelection(_ answer: QDMAnswer)
    func didSelectAnswer(_ answer: QDMAnswer)
    func didDeSelectAnswer(_ answer: QDMAnswer)
    func textCellDidAppear(targetID: Int)
    func didSelectCalendarEvent(_ event: QDMUserCalendarEvent, selectedAnswer: QDMAnswer)
    func presentAddEventController(_ eventStore: EKEventStore)
    func didUpdatePrepareBenefits(_ benefits: String?)
    func didPressDimiss()
    func didPressContinue()
}

private enum CellType: Int, CaseIterable {
    case question
    case answer
}

final class DecisionTreeQuestionnaireViewController: UIViewController {

    // MARK: - Properties
    var interactor: DecisionTreeInteractorInterface?
    weak var delegate: DecisionTreeQuestionnaireDelegate?
    private var selectedAnswers: [DecisionTreeModel.SelectedAnswer]
    private let extraAnswer: String?
    private let question: QDMQuestion
    private let maxPossibleSelections: Int
    private let answersFilter: String?
    private let questionTitleUpdate: String?
    private lazy var typingAnimation = DotsLoadingView(frame: CGRect(x: 24, y: 20, width: 20, height: 20))
    private lazy var tableView = UITableView(delegate: self,
                                             dataSource: self,
                                             dequeables: MultipleSelectionTableViewCell.self,
                                             SingleSelectionTableViewCell.self,
                                             QuestionTableViewCell.self,
                                             TextTableViewCell.self,
                                             CalendarEventsTableViewCell.self,
                                             UserInputTableViewCell.self)

    /// Use filtered answers in order to relate answers between different questions.
    /// E.g.: Based on Question A answer, filter Question B answers to display.
    /// If `answersFilter` is nil, we'll display all possible answers.
    private var filteredAnswers: [QDMAnswer] {
        guard let filter = answersFilter else { return Array(question.answers) }
        return Array(question.answers).filter { $0.keys.contains(filter) }
    }

    // MARK: - Init
    init(for question: QDMQuestion,
         with selectedAnswers: [DecisionTreeModel.SelectedAnswer],
         extraAnswer: String?,
         maxPossibleSelections: Int,
         answersFilter: String?,
         questionTitleUpdate: String?) {
        self.question = question
        self.selectedAnswers = selectedAnswers
        self.extraAnswer = extraAnswer
        self.maxPossibleSelections = maxPossibleSelections
        self.answersFilter = answersFilter
        self.questionTitleUpdate = questionTitleUpdate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addObservers()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recalculateContentInsets()
    }
}

// MARK: - Private
private extension DecisionTreeQuestionnaireViewController {
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(typingAnimationStart),
                                               name: .typingAnimationStart,
                                               object: nil)
    }

    func setupView() {
        attachToEdge(tableView, bottomConstant: -.bottomNavBarHeight)
        tableView.backgroundColor = .sand
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }

    @objc func typingAnimationStart() {
        typingAnimation.startAnimation(withDuration: Animation.duration_3)
    }

    @objc func presentAddEventController() {
        delegate?.presentAddEventController(EKEventStore.shared)
    }

    @objc func didTapContinue() {
        delegate?.didPressContinue()
    }
}

// MARK: - UITableViewDelegate
extension DecisionTreeQuestionnaireViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = CellAnimator.moveUpWithFade(rowHeight: cell.frame.height, duration: 0.01, delayFactor: 0.05)
        let animator = CellAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
        if let inputCell = cell as? UserInputTableViewCell {
            inputCell.showKeyBoard()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = CellType.allCases[indexPath.section]
        if type == .answer && question.answerType == AnswerType.userInput.rawValue {
            return 260
        }
        return UITableViewAutomaticDimension
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
            cell.configure(with: question.title, questionTitleUpdate: questionTitleUpdate)
            return cell
        case .answer:
            switch question.answerType {
            case AnswerType.accept.rawValue:
                let cell = UITableViewCell()
                cell.backgroundColor = .sand
                return cell
            case AnswerType.onlyExistingAnswer.rawValue:
                let cell = UITableViewCell()
                cell.backgroundColor = .sand
                delegate?.textCellDidAppear(targetID: question.answers.first?.decisions.first?.targetTypeId ?? 0)
                return cell
            case AnswerType.yesOrNo.rawValue, AnswerType.uploadImage.rawValue:
                let cell: SingleSelectionTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(for: question, selectedAnswers: selectedAnswers)
                cell.delegate = self
                return cell
            case AnswerType.singleSelection.rawValue,
                 AnswerType.multiSelection.rawValue:
                let cell: MultipleSelectionTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(for: filteredAnswers,
                               question: question,
                               selectedAnswers: selectedAnswers,
                               maxPossibleSelections: maxPossibleSelections)
                cell.delegate = self
                return cell
            case AnswerType.userInput.rawValue:
                let cell: UserInputTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(benefits: interactor?.prepareBenefits, delegate: delegate)
                cell.showKeyBoard()
                return cell
            case AnswerType.noAnswerRequired.rawValue,
                 AnswerType.text.rawValue,
                 AnswerType.lastQuestion.rawValue:
                let cell: TextTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(with: extraAnswer ?? "")
                delegate?.textCellDidAppear(targetID: question.answers.first?.decisions.first?.targetTypeId ?? 0)
                return cell
            case AnswerType.openCalendarEvents.rawValue:
                let cell: CalendarEventsTableViewCell = tableView.dequeueCell(for: indexPath)
                let tableViewHeight = view.frame.height - (cell.frame.height + 64)
                cell.configure(delegate: delegate, tableViewHeight: tableViewHeight, question: question)
                return cell
            default:
                preconditionFailure()
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == CellType.question.rawValue && question.hasTypingAnimation ? .buttonHeight : 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == CellType.question.rawValue && question.hasTypingAnimation {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: .buttonHeight))
            footer.addSubview(typingAnimation)
            typingAnimation.configure(dotsColor: .carbonDark)
            return footer
        }
        return nil
    }
}

// MARK: - Private
private extension DecisionTreeQuestionnaireViewController {
    func recalculateContentInsets() {
        if question.answerType == AnswerType.openCalendarEvents.rawValue {
            return tableView.contentInset = .zero
        }
        if question.answerType == AnswerType.userInput.rawValue {
            return tableView.contentInset = UIEdgeInsets(top: view.frame.height * 0.1, left: 0, bottom: 0, right: 0)
        }
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
    func didSelect(_ answer: QDMAnswer) {
        delegate?.didTapBinarySelection(answer)
    }
}

// MARK: - MultiselectionCellDelegate
extension DecisionTreeQuestionnaireViewController: MultipleSelectionCellDelegate {
    func didSelectAnswer(_ answer: QDMAnswer) {
        delegate?.didSelectAnswer(answer)
    }

    func didDeSelectAnswer(_ answer: QDMAnswer) {
        delegate?.didDeSelectAnswer(answer)
    }
}

// MARK: - Bottom Navigation Items
extension DecisionTreeQuestionnaireViewController {
    @objc override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        switch question.key {
        case QuestionKey.Sprint.last.rawValue?:
            return nil
        default:
            return [dismissNavigationItem()]
        }
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        switch question.key {
        case QuestionKey.Prepare.calendarEventSelectionDaily.rawValue,
             QuestionKey.Prepare.calendarEventSelectionCritical.rawValue?:
            let title = question.defaultButtonText ?? R.string.localized.buttonTitleAddEvent()
            return [roundedDarkButtonItem(title: title,
                                          image: R.image.ic_event(),
                                          buttonWidth: .decisionTreeButtonWidth,
                                          action: #selector(presentAddEventController))]
        case QuestionKey.Recovery.loading.rawValue?,
             QuestionKey.Sprint.introContinue.rawValue?,
             QuestionKey.MindsetShifterTBV.review.rawValue?,
             QuestionKey.Sprint.last.rawValue?:
            let title = question.defaultButtonText ?? R.string.localized.morningControllerDoneButton()
            return [roundedDarkButtonItem(title: title,
                                          buttonWidth: .decisionTreeButtonWidth,
                                          action: #selector(didTapContinue))]
        default:
            return []
        }
    }
}
