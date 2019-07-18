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

final class QuestionnaireViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var progressTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var ovalTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var fillView: UIView!
    @IBOutlet private weak var indexLabel: UILabel!

    private var finishedLoadingInitialTableCells = false
    private var questionIdentifier: Int?
    private var question: String? = nil
    private var items = 10
    private let barWidth = 8
    private let defaultMultiplierForIndex = 1
    private let multiplierForFirstIndex = 4
    private let multiplierForSecondIndex = 2

    private var cellHeight: CGFloat = Layout.padding_24
    private var previousYPosition: CGFloat = 0.0
    private var touchDownYPosition: CGFloat = 0.0
    private var currentIndex: Int = 5
    private var temporaryIndex: Int = -1
    private var presentationType: QuestionnairePresentationType = .selection
    private var showAnimated: Bool = false
    weak var answerDelegate: QuestionnaireAnswer?

    static func viewController<T>(with questionnaire: T,
                                  delegate: QuestionnaireAnswer? = nil,
                                  presentationType: QuestionnairePresentationType = .fill) -> QuestionnaireViewController?
        where T: NewQuestionnaire {
            guard let viewController = R.storyboard.questionnaireViewController.instantiateInitialViewController() else {
                return nil
            }
            // setup questions
            viewController.questionIdentifier = questionnaire.questionIdentifier()
            viewController.question = questionnaire.question()
            viewController.items = questionnaire.items()
            viewController.currentIndex = questionnaire.selectedAnswerIndex()
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
}

// MARK: Animation
extension QuestionnaireViewController {

    func animationHide() {
        questionLabel.isHidden = true
        tableView.isHidden = true
        tableView.reloadData()
        progressView.alpha = 0.0
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
        progressView.alpha = 0.0
        progressTopConstraint.constant = cellHeight * CGFloat(items * 2 - 1)
        fillView.setNeedsUpdateConstraints()

        UIView.animate(withDuration: Animation.duration_02,
                       delay: Animation.duration_02,
                       options: [.curveEaseInOut],
                       animations: {
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
        })
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
        indexLabel.text = String(items - index)
        if isTouch == true {
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
        // handle multipliers
        if indexPath.row == 0 {
            multiplier = multiplierForFirstIndex
        } else if indexPath.row <= 2 {
            multiplier = multiplierForSecondIndex
        }

        // handle colors
        if indexPath.row > currentIndex {
            cell.cellIndicatorView.isAboveCurrentIndex = true
        } else if indexPath.row < currentIndex {
            cell.cellIndicatorView.isBelowCurrentIndex = true
        } else {
            cell.cellIndicatorView.isCurrentIndex = true
        }

        cell.cellIndicatorView.indicatorWidth = CGFloat(barWidth * (items - indexPath.row + multiplier))
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
