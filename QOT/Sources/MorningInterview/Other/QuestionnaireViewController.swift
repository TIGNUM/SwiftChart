//
//  QuestionnaireViewController.swift
//  RatingAnimation
//
//  Created by Sanggeon Park on 22.10.18.
//  Copyright © 2018 Sanggeon Park. All rights reserved.
//

import UIKit

enum QuestionnairePresentationType {
    case selection
    case fill
}

enum DailyCheckInQuestionKey: String {
    case quality = "sleep.quality"
    case amount = "sleep.quantity.time"
    case recovered = "recovery.today"
    case load = "load.today"
    case demad = "load.upcoming.week"
}

enum ControllerType {
    case vision
    case dailyCheckin
    case customize

    struct Config {
        let currentIndexColor: UIColor
        let aboveCurrentIndexColor: UIColor
        let belowCurrentIndexColor: UIColor

        static func myVision() -> Config {
            return Config(currentIndexColor: .redOrange,
                          aboveCurrentIndexColor: .redOrange40,
                          belowCurrentIndexColor: .accent40)
        }

        static func customize() -> Config {
            return Config(currentIndexColor: .redOrange,
                          aboveCurrentIndexColor: .redOrange40,
                          belowCurrentIndexColor: .accent40)
        }

        static func dailyCheckin() -> Config {
            return Config(currentIndexColor: .accent,
                          aboveCurrentIndexColor: .accent70,
                          belowCurrentIndexColor: .accent70)
        }
    }

    var config: Config {
        switch self {
        case .vision:
            return Config.myVision()
        case .dailyCheckin:
            return Config.dailyCheckin()
        case .customize:
            return Config.customize()
        }
    }

    var color: UIColor {
        switch self {
        case .vision:
            return .sand
        case .dailyCheckin:
            return .carbon
        case .customize:
            return .sand
        }
    }
}

final class QuestionnaireViewController: UIViewController, ScreenZLevel3 {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var customizeTargetTitle: UILabel!
    @IBOutlet weak var labelCustomizeView: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var progressTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var ovalTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var progressUpArrowImage: UIImageView!
    @IBOutlet private weak var progressDownArrowImage: UIImageView!
    @IBOutlet private weak var downArrowTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var upArrowBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var fillView: UIView!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var bottomImageView: UIImageView!
    @IBOutlet private weak var topIndex: UILabel!
    @IBOutlet private weak var bottomIndex: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    static var hasArrowsAnimated: Bool = false
    var chosenValue: String?
    private var finishedLoadingInitialTableCells = false
    private var questionIdentifier: Int?
    private var questionHtml: NSAttributedString? = nil
    private var questionText: String? = nil
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
    private var controllerType: ControllerType = .vision
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

            let questionItems = questionnaire.items() ?? 0
            // setup questions
            viewController.questionIdentifier = questionnaire.questionIdentifier()
            viewController.questionHtml = questionnaire.questionHtml()
            viewController.questionText = questionnaire.questionText()
            viewController.items = questionItems
            viewController.answers = questionnaire.getAnswers()
            viewController.currentIndex = questionnaire.selectedQuestionAnswerIndex() ?? questionItems / 2
            viewController.questionkey = DailyCheckInQuestionKey(rawValue: questionnaire.questionKey() ?? "")
            viewController.presentationType = presentationType
            viewController.controllerType = controllerType
            viewController.answerDelegate = delegate
            viewController.dailyCheckinDelegate = dailyCheckinDelegate
            return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        animationHide()
        labelCustomizeView.isHidden = true
        customizeTargetTitle.isHidden = true
        setupView()
        adjustUI()
        progressView.backgroundColor = UIColor.clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

        cellHeight = tableViewHeight/(items == 0 ? CGFloat(1.0) : CGFloat(items))
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

    override func showTransitionBackButton() -> Bool {
        return false
    }
}

// MARK: Animation
extension QuestionnaireViewController {

    func adjustUI() {
        switch controllerType {
        case .customize:
            topConstraint.constant = 50
            labelCustomizeView.isHidden = false
            customizeTargetTitle.isHidden = false
            ThemeText.dailyBriefTitle.apply(R.string.localized.tbvCustomizeTarget(), to: customizeTargetTitle)
            ThemeText.tbvVisionBody.apply(R.string.localized.tbvCustomizeBody(), to: labelCustomizeView)
            ThemeView.level3.apply(view)
            hintLabel.isHidden = true
        default:
            return
        }

    }

    func animateArrows() {
        if QuestionnaireViewController.hasArrowsAnimated { return }
        self.upArrowBottomConstraint.constant = 10
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       animations: {
                        self.progressView.layoutIfNeeded()
        }, completion: {[weak self] (value: Bool) in
            self?.upArrowBottomConstraint.constant = 5
            UIView.animate(withDuration: 0.8,
                           delay: 0,
                           animations: {
                            self?.progressView.layoutIfNeeded()
            }, completion: nil)
        })

        self.downArrowTopConstraint.constant = 10
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       animations: {
                        self.progressView.layoutIfNeeded()
        }, completion: {[weak self] (value: Bool) in
            self?.downArrowTopConstraint.constant = 5
            UIView.animate(withDuration: 0.8,
                           delay: 0,
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

    private func topAndBottomImage(isHidden: Bool) {
        topImageView.isHidden = isHidden
        bottomImageView.isHidden = isHidden
        topIndex.isHidden = !isHidden
        bottomIndex.isHidden = !isHidden
    }

    private func setupView() {
        let color = controllerType.color
        lineView.backgroundColor = color
        indexLabel.textColor = color
        bottomIndex.textColor = color
        topIndex.textColor = color
        questionLabel.textColor = color
    }

    private func setupImages() {
        switch questionkey {
        case .amount?:
            topImageView.image = R.image.sleepBig()
            bottomImageView.image = R.image.sleepSmall()
            topAndBottomImage(isHidden: false)
        case .demad?:
            topImageView.image = R.image.upcomingEventBig()
            bottomImageView.image = R.image.upcomingEventSmall()
            topAndBottomImage(isHidden: false)
        case .load?:
            topImageView.image = R.image.taskBig()
            bottomImageView.image = R.image.taskSmall()
            topAndBottomImage(isHidden: false)
        case .quality?:
            topImageView.image = R.image.waveBig()
            bottomImageView.image = R.image.waveSmall()
            topAndBottomImage(isHidden: false)
        case .recovered?:
            topImageView.image = R.image.recoverBig()
            bottomImageView.image = R.image.recoverSmall()
            topAndBottomImage(isHidden: false)
        default:
            topIndex.text = String(10)
            bottomIndex.text = String(1)
            topAndBottomImage(isHidden: true)
        }
    }

    public func animationShow() {
        showAnimated = true

        tableView.isHidden = true
        tableView.reloadData()
        questionLabel.isHidden = false
        questionLabel.alpha = 0
        progressView.alpha = 0.0
        progressTopConstraint.constant = cellHeight * CGFloat(items * 2 - 1)
        questionLabel.transform = CGAffineTransform(translationX: 0, y: -Layout.padding_100)
        fillView.setNeedsUpdateConstraints()

        switch controllerType {
        case .customize:
            labelCustomizeView.text = R.string.localized.dailyBriefCustomizeSleepIntro()
            questionLabel.attributedText = ThemeText.tbvBody.attributedString(R.string.localized.dailyBriefCustomizeSleepQuestion())
        case .dailyCheckin:
            if let question = questionHtml {
                questionLabel.attributedText = question
                questionLabel.font = UIFont.sfProtextLight(ofSize: 16)
            } else if let question = questionText {
                questionLabel.attributedText = ThemeText.tbvQuestionMedium.attributedString(question)
            }
        case .vision:
            if let question = questionText {
                let combined = NSMutableAttributedString()
                combined.append(ThemeText.tbvQuestionLight.attributedString(R.string.localized.tbvHowWouldYou()))
                combined.append(ThemeText.tbvQuestionMedium.attributedString(" \""))
                combined.append(ThemeText.tbvQuestionMedium.attributedString(question))
                combined.append(ThemeText.tbvQuestionMedium.attributedString("\""))
                questionLabel.attributedText = combined
            }
        }

        UIView.animate(withDuration: Animation.duration_02,
                       delay: Animation.duration_02,
                       options: [.curveEaseInOut],
                       animations: {
                        self.questionLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.questionLabel.alpha = 1
                        self.progressView.alpha = 1
        }, completion: { finished in
            self.setupImages()
            self.tableView.isHidden = false
            self.tableView.reloadData()
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
        }, completion: { finished in
            self.animateArrows()
            QuestionnaireViewController.hasArrowsAnimated = true
        })
    }

    func formTimeAttibutedString(title: String, isLast: Bool) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: title,
                                                    attributes: [.font: UIFont.sfProDisplayThin(ofSize: 34)])
        if questionkey == .amount {
            let maxHourUnit = R.string.localized.dailyCheckInSleepQuantityValueSuffixMax()
            let hoursUnit = R.string.localized.dailyCheckInSleepQuantityValueSuffix()
            attrString.append(NSMutableAttributedString(string: isLast ? maxHourUnit : hoursUnit,
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
                    indexLabel.attributedText = formTimeAttibutedString(title: finalAnswers[answerIndex].subtitle ?? "", isLast: answerIndex == finalAnswers.count - 1)
                    ThemeText.questionHintLabel.apply(finalAnswers[answerIndex].title, to: hintLabel)
                default:
                    indexLabel.attributedText = formTimeAttibutedString(title: finalAnswers[answerIndex].subtitle ?? "", isLast: answerIndex == finalAnswers.count - 1)
                    ThemeText.questionHintLabelDark.apply(finalAnswers[answerIndex].title, to: hintLabel)
                 }
            }
        } else {
            indexLabel.text = String(items - index)
            var subtitles = [R.string.localized.tbvRateNever(), "", "", "", R.string.localized.tbvRateSometimes(), "", "", "", "", R.string.localized.tbvRateAlways()]
            ThemeText.questionHintLabelRed.apply(subtitles[items - index - 1], to: hintLabel)
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
            let indexPath = IndexPath(row: index, section: 0)
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
        return tableView.isHidden ? 0 : items
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionnaireTableViewCell = tableView.dequeueCell(for: indexPath)
        var multiplier = defaultMultiplierForIndex
        cell.cellIndicatorView.config = controllerType.config
        // handle multipliers
        if questionkey == .amount {
            if indexPath.row <= 0 {
                multiplier = multiplierForTimeFirstIndex
            } else if indexPath.row <= 6 {
                multiplier = multiplierForTimeSecondIndex
            } else {
                multiplier = (items - (indexPath.row) + 1)/2
            }
        } else {
            if indexPath.row == 0 {
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
            if indexPath.row % 2 != 0 {
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
        if items > 0 && !finishedLoadingInitialTableCells {
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
            cell.transform = CGAffineTransform(translationX: 0, y: Layout.padding_40).scaledBy(x: 1, y: Layout.multiplier_150)
            cell.alpha = 0

            UIView.animate(withDuration: Animation.duration_02,
                           delay: Animation.duration_01 * Double(indexPath.row),
                           options: [.curveEaseInOut], animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0)
                            cell.alpha = 1
            }, completion: { finished in
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
extension QuestionnaireViewController: UIGestureRecognizerDelegate {
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
        guard let count = answers?.count else { return }
        let value = (count  - 1 - currentIndex)
        // WARNING: This is valid only for daily brief check in Set Sleep Target
        self.answerDelegate?.saveTargetValue(value: value)
        NotificationCenter.default.post(name: .didPickTarget, object: Double(value))
        dismiss(animated: true)
    }
}

//TODO - Removing this fixes the Done button problem but needs more testing around daily brief before removing commented code
extension QuestionnaireViewController {
    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        switch controllerType {
        case .customize:
            return [dismissNavigationItem()]
        default:
            return nil
        }
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        switch controllerType {
        case .customize:
            if saveShouldShow {
                return [roundedBarButtonItem(title: R.string.localized.mySprintDetailsNotesButtonSave(),
                                             buttonWidth: .Done,
                                             action: #selector(didTapSave),
                                             backgroundColor: .clear,
                                             borderColor: .accent)]
            }
        default:
            break
        }
        return nil
    }
}
