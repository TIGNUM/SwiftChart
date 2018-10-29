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
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var progressTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var fillView: UIView!

    private var finishedLoadingInitialTableCells = false
    private var questionIdentifier: Int?
    private var question: String? = nil
    private var answers: [String?] = []
    private var titles: [String?] = []
    private var cellHeight: CGFloat = Layout.padding_32
    private var previousYPosition: CGFloat = 0.0
    private var touchDownYPosition: CGFloat = 0.0
    private var currentIndex: Int = 5
    private var presentationType: QuestionnairePresentationType = .fill
    private var fillColor: UIColor? = nil
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
            viewController.titles = questionnaire.answerDescriptions()
            viewController.answers = questionnaire.answerStrings()
            viewController.currentIndex = questionnaire.selectedAnswerIndex()
            viewController.fillColor = questionnaire.selectionColor()
            viewController.presentationType = presentationType
            viewController.answerDelegate = delegate
            return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        animationHide()
        progressView.backgroundColor = fillColor ?? progressView.backgroundColor
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationShow()
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
        indexLabel.isHidden = true
        tableView.isHidden = true
        tableView.reloadData()
        progressView.alpha = 0.0
    }

    public func animationShow() {
        // start animation
        tableView.isHidden = true
        tableView.reloadData()

        questionLabel.isHidden = false
        questionLabel.transform = CGAffineTransform(translationX: 0, y: -Layout.padding_100)
        questionLabel.alpha = 0
        questionLabel.text = question

        indexLabel.isHidden = false
        indexLabel.alpha = 0

        progressView.alpha = 0.0
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
            UIView.animate(withDuration: Animation.duration_02, delay: Animation.duration_02,
                           options: [.curveEaseInOut], animations: {
                            self.indexLabel.alpha = 1
            }, completion: { finished in
                self.answerDelegate?.isPresented(for: self.questionID(), from: self)
            })
        }
    }

    func itemIndex(with yPosition: CGFloat) -> Int {
        var index = Int(yPosition/self.cellHeight)
        if index > self.titles.count - 1 {
            index = self.titles.count - 1
        }
        return index
    }

    func adjustSelectedAnswer(yPosition position: CGFloat) {
        let index = itemIndex(with: position)
        currentIndex = index
        animateTo(yPosition: CGFloat(index) * cellHeight)
        answerDelegate?.didSelect(answer: answers[currentIndex], for: questionIdentifier, from: self)
    }

    func animateToIndex(index: Int, duration: TimeInterval = 1.0, isTouch: Bool = true) {
        animateTo(yPosition: CGFloat(index) * cellHeight, duration: duration, isTouch: isTouch)
    }

    func animateTo(yPosition position: CGFloat, duration: TimeInterval = 0.1, isTouch: Bool = true) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.dragTo(yPosition: position, isTouch: isTouch)
            self.fillView.setNeedsUpdateConstraints()
            self.fillView.layoutIfNeeded()
        }, completion: nil)
    }

    func dragTo(yPosition position: CGFloat, isTouch: Bool = true) {
        var newPosition = position
        if newPosition < 0 {
            newPosition = 0
        } else if newPosition > (cellHeight * CGFloat(titles.count - 1)) {
            newPosition = cellHeight * CGFloat(titles.count - 1)
        }
        self.progressTopConstraint.constant = newPosition
        let index = itemIndex(with: newPosition)
        if indexLabel.text != answers[index], isTouch == true {
            generateFeedback(.light)
        }
        indexLabel.text = answers[index]
        if isTouch == true {
            answerDelegate?.isSelecting(answer: answers[index], for: questionIdentifier, from: self)
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension QuestionnaireViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.isHidden ? 0 : titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionnaireTableViewCell", for: indexPath)
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
            }, completion: nil)
        }
    }
}

// MARK: GestureRecognizer
extension QuestionnaireViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard gestureRecognizer.view != nil else {return false}
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
    @IBAction func tapPiece(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        let piece = gestureRecognizer.view!
        switch gestureRecognizer.state {
        case .began:
            touchDownYPosition = gestureRecognizer.location(in: piece).y
        case .ended:
            adjustSelectedAnswer(yPosition: touchDownYPosition)
        default:
            break
        }
    }

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
