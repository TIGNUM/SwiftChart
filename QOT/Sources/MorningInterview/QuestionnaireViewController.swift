//
//  QuestionnaireViewController.swift
//  RatingAnimation
//
//  Created by Sanggeon Park on 22.10.18.
//  Copyright © 2018 Sanggeon Park. All rights reserved.
//

import UIKit
import qot_dal

enum QuestionnairePresentationType {
    case selection
    case fill
}

enum DailyCheckInQuestionKey: String {
    case quality = "sleep.quality"
    case amount = "sleep.quantity.time"
    case recovered = "recovery.today"
    case load = "load.today"
    case demand = "load.upcoming.week"
    case peak = "daily.checkin.peak.performances"
}

enum ControllerType {
    case teamVision
    case vision
    case dailyCheckin
    case customize

    struct Config {
        let currentIndexColor: UIColor
        let aboveCurrentIndexColor: UIColor
        let belowCurrentIndexColor: UIColor

        static func newQuestionaireConfig() -> Config {
            return Config(currentIndexColor: .white,
                          aboveCurrentIndexColor: .white,
                          belowCurrentIndexColor: .white40)
        }
    }

    var config: Config {
        return Config.newQuestionaireConfig()
    }

    var color: UIColor {
        return .white
    }
}

final class QuestionnaireViewController: BaseViewController, ScreenZLevel3 {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet private weak var progressTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var ovalTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var progressUpArrowImage: UIImageView!
    @IBOutlet private weak var progressDownArrowImage: UIImageView!
    @IBOutlet private weak var downArrowTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var upArrowBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var fillView: UIView!
    @IBOutlet private weak var bottomImageView: UIImageView!
    @IBOutlet private weak var topIndex: UILabel!
    @IBOutlet private weak var bottomIndex: UILabel!
    @IBOutlet private weak var indexLabel: PaddingLabel!
    static var hasArrowsAnimated: Bool = false
    private var finishedLoadingInitialTableCells = false
    private var questionIdentifier: Int?
    private var questionHtml: NSAttributedString?
    private var questionText: String?
    private var items = 10
    private var answers: [RatingQuestionViewModel.Answer]?
    private var cellHeight: CGFloat = Layout.padding_24
    private let barWidth = 8
    private let defaultMultiplierForIndex = 1
    private let multiplierForFirstIndex = 4
    private let multiplierForSecondIndex = 2
    private let multiplierForTimeFirstIndex = 2
    private let multiplierForTimeSecondIndex = 5
    private var previousYPosition: CGFloat = 0.0
    private var touchDownYPosition: CGFloat = 0.0
    private var currentIndex: Int = 5
    private var temporaryIndex: Int = -1
    private var questionkey: DailyCheckInQuestionKey?
    private var presentationType: QuestionnairePresentationType = .selection
    var controllerType: ControllerType = .vision
    private var showAnimated: Bool = false
    private var saveShouldShow: Bool = false
    weak var answerDelegate: QuestionnaireAnswer?
    weak var dailyCheckinDelegate: DailyBriefViewControllerDelegate?

    static func viewController<T>(with questionnaire: T,
                                  delegate: QuestionnaireAnswer? = nil,
                                  dailyCheckinDelegate: DailyBriefViewControllerDelegate? = nil,
                                  presentationType: QuestionnairePresentationType = .fill,
                                  controllerType: ControllerType = .vision) -> QuestionnaireViewController?
        where T: RatingQuestionnaire {
            guard let viewController = R.storyboard.questionnaireViewController.instantiateInitialViewController() else {
                return nil
            }

            let questionItems = questionnaire.items() ?? .zero
            // setup questions
            viewController.questionIdentifier = questionnaire.questionIdentifier()
            viewController.questionHtml = questionnaire.questionHtml()
            viewController.questionText = questionnaire.questionText()
            viewController.items = questionItems
            viewController.answers = questionnaire.getAnswers()
            viewController.currentIndex = questionnaire.selectedQuestionAnswerIndex() ?? questionItems / 2
            viewController.questionkey = DailyCheckInQuestionKey(rawValue: questionnaire.questionKey() ?? String.empty)
            viewController.presentationType = presentationType
            viewController.controllerType = controllerType
            viewController.answerDelegate = delegate
            viewController.dailyCheckinDelegate = dailyCheckinDelegate
            return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        animationHide()
        setupView()
        adjustUI()
        progressView.backgroundColor = UIColor.clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
        if showAnimated == false {
            animationShow()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationHide()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Check TableView Size and set right cell height
        let tableViewHeight = tableView.bounds.height

        cellHeight = tableViewHeight/(items == .zero ? CGFloat(1.0) : CGFloat(items))
        progressHeightConstraint.constant = presentationType == .fill ? tableViewHeight * 2 : cellHeight
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        animationHide()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Animation.duration_02) {
            self.animationShow()
        }
    }

    func itemsCount() -> Int {
        return items
    }

    public func questionID() -> Int {
        return questionIdentifier ?? NSNotFound
    }

    public func currentAnswerIndex() -> Int {
        return currentIndex
    }

    override func showTransitionBackButton() -> Bool {
        return false
    }
}

// MARK: Animation
extension QuestionnaireViewController {
    func adjustUI() {
        ThemeView.level3.apply(view)
        questionLabelTopConstraint.constant = controllerType == .customize ? 59.0 : 15.0
    }

    func animateArrows() {
        if QuestionnaireViewController.hasArrowsAnimated { return }
        self.upArrowBottomConstraint.constant = 10
        UIView.animate(withDuration: 0.8,
                       delay: .zero,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       animations: {
                        self.progressView.layoutIfNeeded()
        }, completion: {[weak self] (_: Bool) in
            self?.upArrowBottomConstraint.constant = 5
            UIView.animate(withDuration: 0.8,
                           delay: .zero,
                           animations: {
                            self?.progressView.layoutIfNeeded()
            }, completion: nil)
        })

        self.downArrowTopConstraint.constant = 10
        UIView.animate(withDuration: 0.8,
                       delay: .zero,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       animations: {
                        self.progressView.layoutIfNeeded()
        }, completion: {[weak self] (_: Bool) in
            self?.downArrowTopConstraint.constant = 5
            UIView.animate(withDuration: 0.8,
                           delay: .zero,
                           animations: {
                            self?.progressView.layoutIfNeeded()
            }, completion: nil)
        })
    }

    func animationHide() {
        questionLabel.isHidden = true
        tableView.isHidden = true
        tableView.reloadData()
        progressView.alpha = 0.0
        showAnimated = false
    }

    private func setupView() {
        let color = controllerType.color
        totalHoursLabel.isHidden = true
        indexLabel.textColor = color
        indexLabel.layer.borderColor = color.cgColor
        indexLabel.layer.borderWidth = 0.0
        bottomIndex.textColor = color
        topIndex.textColor = color
        questionLabel.textColor = color
    }

    private func setupImages() {
        if let answers = self.answers {
            topIndex.text = answers.last?.title
            bottomIndex.text = answers.first?.title
        } else {
            switch controllerType {
            case .vision:
                topIndex.text = AppTextService.get(.my_qot_my_tbv_tbv_tracker_questionnaire_section_body_label_rate_always)
                bottomIndex.text = AppTextService.get(.my_qot_my_tbv_tbv_tracker_questionnaire_section_body_label_rate_never)
            case .teamVision:
                topIndex.text = AppTextService.get(.my_x_team_tbv_questionnaire_top_label)
                bottomIndex.text = AppTextService.get(.my_x_team_tbv_questionnaire_bottom_label)
            default:
                break
            }
        }
    }

    public func animationShow() {
        showAnimated = true

        tableView.isHidden = true
        tableView.reloadData()
        questionLabel.isHidden = false
        questionLabel.alpha = .zero
        progressView.alpha = 0.0
        progressTopConstraint.constant = cellHeight * CGFloat(items * 2 - 1)
        questionLabel.transform = CGAffineTransform(translationX: .zero, y: -Layout.padding_100)
        fillView.setNeedsUpdateConstraints()
        var questionString = String.empty
        switch controllerType {
        case .customize:
            questionString = AppTextService.get(.daily_brief_customize_sleep_amount_section_question_question)
        case .dailyCheckin:
            questionString = (questionHtml == nil ? questionText : questionHtml?.string) ?? String.empty
        case .vision:
            if let sentence = questionText?.trimmingCharacters(in: .whitespaces) {
                let personalQuestion = AppTextService.get(.my_qot_my_tbv_tbv_tracker_questionnaire_section_body_body_rate_yourself)
                questionString = createQuestion(sentence: sentence,
                                                question: personalQuestion)
            }
        case .teamVision:
            if let sentence = questionText?.trimmingCharacters(in: .whitespaces) {
                let teamQuestion = AppTextService.get(.my_x_team_vision_tracker_question)
                questionString = createQuestion(sentence: sentence,
                                                question: teamQuestion)
            }
        }
        questionLabel.text = questionString
        UIView.animate(withDuration: Animation.duration_01,
                       delay: Animation.duration_01,
                       options: [.curveEaseInOut],
                       animations: {
                        self.questionLabel.transform = CGAffineTransform(translationX: .zero, y: .zero)
                        self.questionLabel.alpha = 1
                        self.progressView.alpha = 1
        }, completion: { [weak self] _ in
            self?.setupImages()
            self?.questionLabel.alpha = 1
            self?.questionLabel.isHidden = false
            self?.tableView.isHidden = false
            self?.questionLabel.text = questionString
            self?.tableView.reloadData()
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + Animation.duration_02) {
            self.animateToIndex(index: self.currentIndex, isTouch: false)
            self.answerDelegate?.isPresented(for: self.questionID(), from: self)
        }
    }

    func itemIndex(with yPosition: CGFloat) -> Int {
        var index = Int(yPosition + cellHeight/2)/Int(cellHeight)
        if index > self.items - 1 {
            index = self.items - 1
        }
        return index
    }

    func createQuestion(sentence: String, question: String) -> String {
        let combined = question + " \"" + sentence + "\"" + "?"

        return combined
    }

    func adjustSelectedAnswer(yPosition position: CGFloat) {
        let index = itemIndex(with: position)
        adjustSelectedAnswer(with: index)
    }

    func adjustSelectedAnswer(with index: Int, duration: TimeInterval = 0.2) {
        currentIndex = index
        animateTo(yPosition: CGFloat(index) * cellHeight, duration: duration)
        answerDelegate?.didSelect(answer: currentIndex, for: questionIdentifier, from: self)
    }

    func animateToIndex(index: Int, duration: TimeInterval = 1.0, isTouch: Bool = true) {
        animateTo(yPosition: CGFloat(index) * cellHeight, duration: duration, isTouch: isTouch)
    }

    func animateTo(yPosition position: CGFloat, duration: TimeInterval = 0.2, isTouch: Bool = true) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.dragTo(yPosition: position, isTouch: isTouch)
            self.fillView.setNeedsUpdateConstraints()
            self.fillView.layoutIfNeeded()
        }, completion: { _ in
            self.animateArrows()
            QuestionnaireViewController.hasArrowsAnimated = true
        })
    }

    func formTimeAttibutedString(title: String, isLast: Bool) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: title,
                                                    attributes: [.font: UIFont.sfProDisplayThin(ofSize: 34)])
        if questionkey == .amount {
            let maxHourUnit = AppTextService.get(.daily_brief_daily_check_in_questionnaire_section_slider_subtitle_hours_more)
            let hoursUnit = AppTextService.get(.daily_brief_daily_check_in_questionnaire_section_slider_subtitle_hours)
            attrString.append(NSMutableAttributedString(string: isLast ? maxHourUnit : hoursUnit,
                                                        attributes: [.font: UIFont.sfProDisplayLight(ofSize: 14)]))
        } else if questionkey == .peak {
            let moreText = AppTextService.get(.daily_brief_daily_check_in_questionnaire_section_slider_subtitle_peak_perpormances_more)
            attrString.append(NSMutableAttributedString(string: isLast ? moreText : " ",
                                                        attributes: [.font: UIFont.sfProDisplayLight(ofSize: 14)]))
        }
        return attrString
    }

    func dragTo(yPosition position: CGFloat, isTouch: Bool = true) {
        var newPosition = position
        if newPosition < (-cellHeight/2) {
            newPosition = -cellHeight/2
        } else if newPosition > (cellHeight * CGFloat(items - 1) + cellHeight/2) {
            newPosition = cellHeight * CGFloat(items - 1) + cellHeight/2
        }
        self.progressTopConstraint.constant = newPosition
        let index = itemIndex(with: newPosition)
        applyGradientColor(at: index)
        if temporaryIndex != index {
            temporaryIndex = index
            ovalTopConstraint.constant = CGFloat(temporaryIndex) * cellHeight
            DispatchQueue.main.async {
                if isTouch == true {
                    self.generateFeedback(.light)
                }
            }
        }

        if let finalAnswers = answers {
            let answerIndex = items - index - 1
            if answerIndex < finalAnswers.count {
                switch controllerType {
                case .customize:
                    indexLabel.attributedText = formTimeAttibutedString(title: finalAnswers[answerIndex].subtitle ?? String.empty,
                                                                        isLast: answerIndex == finalAnswers.count - 1)
                    let subtitle = AppTextService.get(.daily_brief_customize_sleep_amount_section_question_subtitle)
//                    calculating 5 days * target amount of sleep relative to answerIndex
                    let hoursLabelText = subtitle.replacingOccurrences(of: "$(amount)", with: String(((answerIndex / 2) + 1) * 5))
                    if !hoursLabelText.isEmpty {
                        totalHoursLabel.isHidden = false
                        ThemeText.asterixText.apply(hoursLabelText, to: totalHoursLabel)
                    }
                default:
                    indexLabel.attributedText = formTimeAttibutedString(title: finalAnswers[answerIndex].subtitle ?? String.empty,
                                                                        isLast: answerIndex == finalAnswers.count - 1)
                    indexLabel.layer.borderWidth = finalAnswers[answerIndex].subtitle?.count ?? .zero > .zero ? 1.0 : 0.0
                 }
            }
        } else {
            indexLabel.text = String(items - index)
            indexLabel.layer.borderWidth = 1.0
        }

        if isTouch == true {
            switch index {
            case 0:
                progressUpArrowImage.isHidden = true
            case items - 1:
                progressDownArrowImage.isHidden = true
            default:
                progressUpArrowImage.isHidden = false
                progressDownArrowImage.isHidden = false
            }
            answerDelegate?.isSelecting(answer: index, for: questionIdentifier, from: self)
        }
    }

    func applyGradientColor(at selectedIndex: Int) {
        for index in 0...(items-1) {
            let indexPath = IndexPath(row: index, section: .zero)
            guard let cell = tableView.cellForRow(at: indexPath) as? QuestionnaireTableViewCell else { continue }
            if index > selectedIndex {
                cell.cellIndicatorView.isAboveCurrentIndex = true
            } else if index < selectedIndex {
                cell.cellIndicatorView.isBelowCurrentIndex = true
            } else {
                cell.cellIndicatorView.isCurrentIndex = true
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension QuestionnaireViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.isHidden ? .zero : items
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionnaireTableViewCell = tableView.dequeueCell(for: indexPath)
        var multiplier = defaultMultiplierForIndex
        cell.cellIndicatorView.config = controllerType.config
        // handle multipliers
        if questionkey == .amount {
            if indexPath.row <= .zero {
                multiplier = multiplierForTimeFirstIndex
            } else if indexPath.row <= 6 {
                multiplier = multiplierForTimeSecondIndex
            } else {
                multiplier = (items - (indexPath.row) + 1)/2
            }
        } else {
            if indexPath.row == .zero {
                multiplier = multiplierForFirstIndex
            } else if indexPath.row <= 2 {
                multiplier = multiplierForSecondIndex
            }
        }

        // handle colors
        if indexPath.row > currentIndex {
            cell.cellIndicatorView.isAboveCurrentIndex = true
        } else if indexPath.row < currentIndex {
            cell.cellIndicatorView.isBelowCurrentIndex = true
        } else {
            cell.cellIndicatorView.isCurrentIndex = true
        }

        if questionkey == .amount {
            if indexPath.row % 2 != .zero{
                cell.cellIndicatorView.isTimeAmountSecondaryIndex = true
                cell.cellIndicatorView.indicatorWidth = CGFloat(6)
            } else {
                let multiplierValue = CGFloat(barWidth * multiplier)
                let width = CGFloat((items - indexPath.row + 1) * barWidth) - multiplierValue
                cell.cellIndicatorView.indicatorWidth = width
            }
        } else {
            cell.cellIndicatorView.indicatorWidth = CGFloat(barWidth * (items - indexPath.row + multiplier))
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var lastInitialDisplayableCell = false
        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
        if items > .zero && !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }

        if finishedLoadingInitialTableCells == false {
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            //animates the cell as it is being displayed for the first time
            cell.transform = CGAffineTransform(translationX: .zero, y: Layout.padding_40).scaledBy(x: 1, y: Layout.multiplier_150)
            cell.alpha = .zero

            UIView.animate(withDuration: Animation.duration_02,
                           delay: Animation.duration_01 * Double(indexPath.row),
                           options: [.curveEaseInOut], animations: {
                            cell.transform = CGAffineTransform(translationX: .zero, y: .zero)
                            cell.alpha = 1
            }, completion: { _ in
                if self.finishedLoadingInitialTableCells {
                    self.applyGradientColor(at: self.currentIndex)
                }
            })
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        adjustSelectedAnswer(with: indexPath.row)
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        animateToIndex(index: indexPath.row, duration: Animation.duration_02)
        generateFeedback(.light)
        return true
    }
}

// MARK: GestureRecognizer
extension QuestionnaireViewController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard gestureRecognizer.view != nil else { return false }
        let piece = gestureRecognizer.view!
        let yPosition = touch.location(in: piece).y
        if touch.phase == .began {
            touchDownYPosition = yPosition
            saveShouldShow = true
            switch controllerType {
            case .customize:
                refreshBottomNavigationItems()
            default:
                break
            }
        }
        return true
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Only pangesture
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
        // Only vertical direction
        return abs(velocity.y) > abs(velocity.x)
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

extension QuestionnaireViewController {
    @IBAction func panPiece(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        let piece = gestureRecognizer.view!
        let yPosition = gestureRecognizer.location(in: piece).y
        switch gestureRecognizer.state {
        case .began:
            touchDownYPosition = yPosition
            previousYPosition = yPosition
        case .changed:
            animateTo(yPosition: self.progressTopConstraint.constant + (yPosition - previousYPosition))
            previousYPosition = yPosition
        case .ended:
            adjustSelectedAnswer(yPosition: self.progressTopConstraint.constant + (yPosition - previousYPosition))
        case .cancelled:
            touchDownYPosition = yPosition
        default:
            break
        }
    }

    @objc func didTapSave() {
        trackUserEvent(.SAVE, action: .TAP)
        guard let count = answers?.count else { return }
        let value = (count  - 1 - currentIndex)
        // WARNING: This is valid only for daily brief check in Set Sleep Target
        self.answerDelegate?.saveTargetValue(value: value)
        NotificationCenter.default.post(name: .didPickTarget, object: Double(value))
        switch controllerType {
        case .customize:
            navigationController?.popViewController(animated: true)
        case .dailyCheckin:
            dismiss(animated: true)
        default:
            break
        }

    }
}

extension QuestionnaireViewController {
    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        switch controllerType {
        case .customize:
            return [backNavigationItem()]
        case .dailyCheckin:
            guard let pageController = parent as? UIPageViewController, let targetVC = pageController.parent else {
                return nil
            }
            return targetVC.bottomNavigationLeftBarItems()
        default:
            return nil
        }
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        switch controllerType {
        case .customize:
            if saveShouldShow {
                return [roundedBarButtonItem(title: AppTextService.get(.my_qot_my_sprints_my_sprint_details_edit_notes_button_save),
                                             buttonWidth: .Done,
                                             action: #selector(didTapSave),
                                             backgroundColor: .clear,
                                             borderColor: .white)]
            }
        case .dailyCheckin:
            guard let pageController = parent as? UIPageViewController, let targetVC = pageController.parent else {
                return nil
            }
            return targetVC.bottomNavigationRightBarItems()
        default:
            break
        }
        return nil
    }
}
