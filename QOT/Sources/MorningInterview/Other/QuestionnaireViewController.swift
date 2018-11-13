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

class QuestionnaireViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var progressTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var ovalTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var fillView: UIView!
    @IBOutlet private weak var backlightView: UIImageView!

    private var finishedLoadingInitialTableCells = false
    private var questionIdentifier: Int?
    private var question: String? = nil
    private var attributedQuestion: NSAttributedString? = nil
    private var answers: [String?] = []
    private var titles: [String?] = []
    private var cellHeight: CGFloat = Layout.padding_32
    private var previousYPosition: CGFloat = 0.0
    private var touchDownYPosition: CGFloat = 0.0
    private var currentIndex: Int = 5
    private var temporaryIndex: Int = -1 {
        didSet {
            applyGradientColor(at: temporaryIndex)
        }
    }
    private var presentationType: QuestionnairePresentationType = .selection
    private var fillColor: UIColor? = nil
    private var gradientTopColor: UIColor? = nil
    private var gradientBottomColor: UIColor? = nil
    private var showAnimated: Bool = false
    weak open var answerDelegate: QuestionnaireAnswer?

    static func viewController<T>(with questionnaire: T,
                                  delegate: QuestionnaireAnswer? = nil,
                                  presentationType: QuestionnairePresentationType = .fill) -> QuestionnaireViewController?
        where T: Questionnaire {
            let storyBoard = UIStoryboard(name: "QuestionnaireViewController", bundle: Bundle.main)
            guard let viewController = storyBoard.instantiateInitialViewController() as? QuestionnaireViewController else {
                return nil
            }
            // setup questions
            viewController.questionIdentifier = questionnaire.questionIdentifier()
            viewController.question = questionnaire.question()
            viewController.attributedQuestion = questionnaire.attributedQuestion()
            viewController.titles = questionnaire.answerDescriptions()
            viewController.answers = questionnaire.answerStrings()
            viewController.currentIndex = questionnaire.selectedAnswerIndex()
            viewController.fillColor = questionnaire.selectionColor()
            viewController.gradientTopColor = questionnaire.gradientTopColor()
            viewController.gradientBottomColor = questionnaire.gradientBottomColor()
            viewController.presentationType = presentationType
            viewController.answerDelegate = delegate
            return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        animationHide()
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

        cellHeight = tableViewHeight/(titles.count == 0 ? CGFloat(1.0) : CGFloat(titles.count))
        progressHeightConstraint.constant = presentationType == .fill ? tableViewHeight * 2 : cellHeight
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        animationHide()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Animation.duration_02) {
            self.animationShow()
        }
    }

    public func questionID() -> Int {
        return questionIdentifier ?? Int(NSNotFound)
    }
}

// MARK: Animation
extension QuestionnaireViewController {

    func animationHide() {
        questionLabel.isHidden = true
        tableView.isHidden = true
        tableView.reloadData()
        progressView.alpha = 0.0
        backlightView.alpha = 0.0
        showAnimated = false
    }

    public func animationShow() {
        // start animation
        tableView.isHidden = true
        showAnimated = true
        tableView.reloadData()

        questionLabel.isHidden = false
        questionLabel.transform = CGAffineTransform(translationX: 0, y: -Layout.padding_100)
        questionLabel.alpha = 0
        questionLabel.text = question
        if let attributed = attributedQuestion {
            questionLabel.attributedText = attributed
        }

        progressView.alpha = 0.0
        backlightView.alpha = 0.0
        progressTopConstraint.constant = cellHeight * CGFloat(titles.count * 2 - 1)
        fillView.setNeedsUpdateConstraints()

        UIView.animate(withDuration: Animation.duration_02, delay: Animation.duration_02,
                       options: [.curveEaseInOut], animations: {
                self.questionLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                self.questionLabel.alpha = 1
                self.progressView.alpha = 1
        }, completion: { finished in
            self.tableView.isHidden = false
            self.tableView.reloadData()
        })

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Animation.duration_02) {
            self.animateToIndex(index: self.currentIndex, isTouch: false)
            self.answerDelegate?.isPresented(for: self.questionID(), from: self)
            self.applyMagnification()
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Animation.duration_02 * 2) {
            self.applyMagnification()
        }
    }

    func itemIndex(with yPosition: CGFloat) -> Int {
        var index = Int(yPosition + cellHeight/2)/Int(cellHeight)
        if index > self.titles.count - 1 {
            index = self.titles.count - 1
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
        answerDelegate?.didSelect(answer: answers[currentIndex], for: questionIdentifier, from: self)
    }

    func animateToIndex(index: Int, duration: TimeInterval = 1.0, isTouch: Bool = true) {
        animateTo(yPosition: CGFloat(index) * cellHeight, duration: duration, isTouch: isTouch)
    }

    func animateTo(yPosition position: CGFloat, duration: TimeInterval = 0.2, isTouch: Bool = true) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.dragTo(yPosition: position, isTouch: isTouch)
            self.backlightView.alpha = 1
            self.fillView.setNeedsUpdateConstraints()
            self.fillView.layoutIfNeeded()
        }, completion: nil)
    }

    func dragTo(yPosition position: CGFloat, isTouch: Bool = true) {
        var newPosition = position
        if newPosition < (-cellHeight/2) {
            newPosition = -cellHeight/2
        } else if newPosition > (cellHeight * CGFloat(titles.count - 1) + cellHeight/2) {
            newPosition = cellHeight * CGFloat(titles.count - 1) + cellHeight/2
        }
        self.progressTopConstraint.constant = newPosition
        let index = itemIndex(with: newPosition)
        if temporaryIndex != index {
            temporaryIndex = index
            ovalTopConstraint.constant = CGFloat(temporaryIndex) * cellHeight
            DispatchQueue.main.async {
                if isTouch == true {
                    self.generateFeedback(.light)
                }
            }
        }
        DispatchQueue.main.async {
            self.applyMagnification()
        }
        if isTouch == true {
            answerDelegate?.isSelecting(answer: answers[index], for: questionIdentifier, from: self)
        }

    }

    func applyGradientColor(at selectedIndex: Int) {
        for index in answers.indices {
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? QuestionnaireTableViewCell else { continue }
            var targetColor = UIColor.white40
            if index >= selectedIndex, let topColor = gradientTopColor, let bottomColor = gradientBottomColor {
                targetColor = topColor.toColor(bottomColor, ratio: CGFloat(index)/CGFloat(answers.count - 1))
            }
            UIView.animate(withDuration: Animation.duration_02, delay: 0, options: [.curveEaseInOut], animations: {
                cell.colorIndicator.setEnable(targetColor != UIColor.white40, with: targetColor)
                if targetColor != UIColor.white40 {
                    cell.textLabel?.textColor = UIColor.white
                } else {
                    cell.textLabel?.textColor = UIColor.white40
                }
                cell.detailTextLabel?.textColor = cell.textLabel?.textColor
            }, completion: nil)
        }
    }

    func applyMagnification() {
        let adjustment: CGFloat = cellHeight/2
        for index in answers.indices {
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? QuestionnaireTableViewCell else { continue }
            var scaleFactor: CGFloat = 1
            let basePosition = CGFloat(index) * cellHeight + adjustment
            let distanceGap = ((progressTopConstraint.constant + adjustment) - basePosition)/cellHeight
            if  abs(distanceGap) < 2 {
                // take range -2 < x < 2 and use following Quadratic equation
                // y = pow(x - 2) * pow(x - 2) / 32
                scaleFactor = scaleFactor + (pow((distanceGap - 2), 2)*pow((distanceGap + 2), 2))/pow(2, 5)
            }
            // adjust scalefacor with screen size, based on cell height
            let baseCellHeight = Layout.padding_40
            if cellHeight < baseCellHeight {
                scaleFactor = scaleFactor * (Layout.padding_32/cellHeight)
            }
            guard let size = cell.textLabel?.sizeThatFits(cell.contentView.bounds.size) else { continue }
            UIView.animate(withDuration: Animation.duration_02, delay: 0, options: [.curveEaseInOut], animations: {
                cell.valueLabelWidth.constant = size.width
                cell.valueLabelLeading.constant = Layout.padding_10 * scaleFactor
                cell.contentView.updateConstraints()
                cell.contentView.layoutIfNeeded()
                cell.textLabel?.transform = CGAffineTransform.identity.scaledBy(x: scaleFactor, y: scaleFactor)
            }, completion: nil)
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension QuestionnaireViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.isHidden ? 0 : titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionnaireTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.detailTextLabel?.text = titles[indexPath.row]?.capitalized
        cell.textLabel?.text = answers[indexPath.row]?.capitalized
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var lastInitialDisplayableCell = false
        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
        if titles.count > 0 && !finishedLoadingInitialTableCells {
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
}
