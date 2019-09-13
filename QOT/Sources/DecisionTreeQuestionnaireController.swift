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
    func textCellDidAppear(targetID: Int, questionKey: String?)
    func didSelectCalendarEvent(_ event: QDMUserCalendarEvent, selectedAnswer: QDMAnswer)
    func didSelectPreparation(_ prepartion: QDMUserPreparation)
    func presentAddEventController(_ eventStore: EKEventStore)
    func didUpdateUserInput(_ userInput: String?)
    func didPressDimiss()
    func didPressContinue()
    func presentSprints()
    func presentTrackTBV()
}

final class DecisionTreeQuestionnaireViewController: UIViewController, ScreenZLevelIgnore {

    // MARK: - Properties
    var interactor: DecisionTreeInteractorInterface?
    weak var delegate: DecisionTreeQuestionnaireDelegate?
    private var selectedAnswers: [DecisionTreeModel.SelectedAnswer]
    private let extraAnswer: String?
    private let question: QDMQuestion
    private let maxPossibleSelections: Int
    private let answersFilter: String?
    private let questionTitleUpdate: String?
    private let preparations: [QDMUserPreparation]?
    let isOnboarding: Bool
    private var reportedTracking: Bool = false // Tracking is reported in `cellForRow` which is called multiple times
    private lazy var typingAnimation = DotsLoadingView(frame: CGRect(x: 24, y: 0, width: 20, height: .TypingFooter))
    private var heightQuestionCell: CGFloat = 0
    private var heightAnswerCell: CGFloat = 0
    lazy var tableView = UITableView(estimatedRowHeight: 100,
                                     delegate: self,
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
        if question.key == QuestionKey.Prepare.BuildCritical {
            if preparations?.isEmpty == true {
                return Array(question.answers).filter { $0.keys.contains(AnswerKey.Prepare.PeakPlanNew) }
            }
            return question.answers
        }
        guard let filter = answersFilter else { return Array(question.answers) }
        return Array(question.answers).filter { $0.keys.contains(filter) }
    }

    // MARK: - Init
    init(for question: QDMQuestion,
         with selectedAnswers: [DecisionTreeModel.SelectedAnswer],
         extraAnswer: String?,
         maxPossibleSelections: Int,
         answersFilter: String?,
         questionTitleUpdate: String?,
         preparations: [QDMUserPreparation]? = nil,
         isOnboarding: Bool = false) {
        self.question = question
        self.selectedAnswers = selectedAnswers
        self.extraAnswer = extraAnswer
        self.maxPossibleSelections = maxPossibleSelections
        self.answersFilter = answersFilter
        self.questionTitleUpdate = questionTitleUpdate
        self.preparations = preparations
        self.isOnboarding = isOnboarding
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

    // MARK: - Public
    func getUserInputCell() -> UserInputTableViewCell? {
        return tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? UserInputTableViewCell
    }
}

// MARK: - Private
private extension DecisionTreeQuestionnaireViewController {
    func setupView() {
        attachToEdge(tableView, bottomConstant: -.BottomNavBar)
        tableView.backgroundColor = interactor?.type.backgroundColor ?? .sand
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(typingAnimationStart),
                                               name: .typingAnimationStart,
                                               object: nil)
    }

    @objc func typingAnimationStart() {
        guard question.hasTypingAnimation else { return }
        tableView.scrollToBottom(animated: true)
        typingAnimation.alpha = 1
        typingAnimation.startAnimation(withDuration: Animation.duration_3)
    }

    @objc func presentAddEventController() {
        delegate?.presentAddEventController(EKEventStore.shared)
    }

    @objc func didTapContinue() {
        delegate?.didPressContinue()
    }

    @objc func didTapDoItLater() {
        delegate?.presentSprints()
    }

    @objc func didTapTrackTBV() {
        delegate?.presentTrackTBV()
    }

    @objc func dismissAll() {
        interactor?.dismissAll()
    }
}

// MARK: - UITableViewDelegate
extension DecisionTreeQuestionnaireViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = CellAnimator.moveUpWithFade(rowHeight: cell.frame.height, duration: 0.01, delayFactor: 0.05)
        let animator = CellAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)

        switch indexPath.section {
        case 0: heightQuestionCell = cell.frame.height
        case 1: heightAnswerCell = cell.frame.height
        default: break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch CellType.allCases[indexPath.section] {
        case .answer where (question.answerType == AnswerType.userInput.rawValue):
            return 260
        case .answer where (question.answerType == AnswerType.accept.rawValue):
            return 0
        default:
            return UITableViewAutomaticDimension
        }
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
        // Tracking
        if QuestionKey.MindsetShifterTBV.Review == question.key && !reportedTracking {
            reportedTracking = true
            trackPage()
        }
        // Display data
        let type = CellType.allCases[indexPath.section]
        switch type {
        case .question:
            let cell: QuestionTableViewCell = tableView.dequeueCell(for: indexPath)
            var update = questionTitleUpdate
            var questionTitle: String? = question.title
            var questionHtml: String?

            if let type = interactor?.type {
                let isFirstQuestion = type.introKey == question.key
                switch (type, isFirstQuestion) {
                case (.sprint, false):
                    update = interactor?.selectedSprintTitle
                case (.mindsetShifterTBVOnboarding, true):
                    questionHtml = question.htmlTitleString
                    questionTitle = nil
                default: break
                }
            }
            cell.configure(with: questionTitle,
                           html: questionHtml,
                           questionTitleUpdate: update,
                           textColor: interactor?.type.textColor ?? .carbon)
            return cell
        case .answer:
            switch question.answerType {
            case AnswerType.accept.rawValue:
                let cell = UITableViewCell()
                cell.backgroundColor = interactor?.type.backgroundColor
                return cell
            case AnswerType.onlyExistingAnswer.rawValue:
                let cell = UITableViewCell()
                cell.backgroundColor = interactor?.type.backgroundColor
                notifyCellDidAppearIfNeeded()
                return cell
            case AnswerType.yesOrNo.rawValue,
                 AnswerType.uploadImage.rawValue:
                let cell: SingleSelectionTableViewCell = tableView.dequeueCell(for: indexPath)
//                cell.configure(for: question, type: interactor?.type, selectedAnswers: selectedAnswers)
//                cell.delegate = self
                return cell
            case AnswerType.singleSelection.rawValue,
                 AnswerType.multiSelection.rawValue:
                switch question.key {
                case QuestionKey.Prepare.SelectExisting:
                    let cell: CalendarEventsTableViewCell = tableView.dequeueCell(for: indexPath)
                    let tableViewHeight = view.frame.height - (cell.frame.height + 64)
                    cell.configure(delegate: delegate, tableViewHeight: tableViewHeight, question: question)
                    return cell
                default:
                    let cell: MultipleSelectionTableViewCell = tableView.dequeueCell(for: indexPath)
//                    cell.configure(for: filteredAnswers,
//                                   question: question,
//                                   selectedAnswers: selectedAnswers,
//                                   maxPossibleSelections: maxPossibleSelections)
//                    cell.delegate = self
                    return cell
                }
            case AnswerType.userInput.rawValue:
                let cell: UserInputTableViewCell = tableView.dequeueCell(for: indexPath)
                let text = question.key == QuestionKey.Prepare.BenefitsInput ? interactor?.userInput : nil
                cell.configure(inputText: text,
                               maxCharacters: QuestionKey.maxCharacter(question.key),
                               delegate: delegate)
                return cell
            case AnswerType.noAnswerRequired.rawValue,
                 AnswerType.text.rawValue,
                 AnswerType.lastQuestion.rawValue:
                let cell: TextTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(with: extraAnswer ?? "",
                               textColor: interactor?.type.textColor)
                notifyCellDidAppearIfNeeded()
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
        return section == CellType.question.rawValue && question.hasTypingAnimation ? .TypingFooter : 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == CellType.question.rawValue && question.hasTypingAnimation {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: .TypingFooter))
            footer.addSubview(typingAnimation)
            typingAnimation.configure(dotsColor: .carbonNew)
            typingAnimation.alpha = 0
            return footer
        }
        return nil
    }
}

// MARK: - Private
private extension DecisionTreeQuestionnaireViewController {
//    func recalculateContentInsets(at indexPath: IndexPath) {
//        if question.answerType == AnswerType.openCalendarEvents.rawValue
//            || question.key == QuestionKey.Prepare.SelectExisting {
//            return tableView.contentInset = .zero
//        }
//        if question.answerType == AnswerType.userInput.rawValue {
//            return tableView.contentInset = .zero
//        }
//        let isTypingQuestion = (CellType.question.rawValue == indexPath.section && question.hasTypingAnimation)
//        let footerHeight: CGFloat = isTypingQuestion ? .TypingFooter : 0
//        let cellsHeight = heightQuestionCell + heightAnswerCell + footerHeight
//        let difference = tableView.frame.height - cellsHeight
//        tableView.contentInset = UIEdgeInsets(top: max(difference, 0), left: 0, bottom: 0, right: 0)
//    }

    func notifyCellDidAppearIfNeeded() {
        if QuestionKey.shouldNotifyAnswerDidAppear(question.key) {
            delegate?.textCellDidAppear(targetID: question.answers.first?.decisions.first?.targetTypeId ?? 0,
                                        questionKey: question.key)
        }
    }
}

//// MARK: - SingleSelectionCellDelegate
//extension DecisionTreeQuestionnaireViewController: SingleSelectionCellDelegate {
//    func didSelect(_ answer: QDMAnswer) {
//        delegate?.didTapBinarySelection(answer)
//    }
//}

// MARK: - MultiselectionCellDelegate
//extension DecisionTreeQuestionnaireViewController: MultipleSelectionCellDelegate {
//    func didSelectAnswer(_ answer: QDMAnswer) {
//        delegate?.didSelectAnswer(answer)
//    }
//
//    func didDeSelectAnswer(_ answer: QDMAnswer) {
//        delegate?.didDeSelectAnswer(answer)
//    }
//}

// MARK: - navigation bar
extension DecisionTreeQuestionnaireViewController {
    override func showTransitionBackButton() -> Bool {
        return false
    }
}
