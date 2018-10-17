//
//  MorningInterviewViewController.swift
//
//  Created by Javier Sanz Rozalen on 15/12/2017.
//  Copyright © 2017 Javier Sanz Rozalen. All rights reserved.
//

import UIKit
import Anchorage

class MorningInterviewViewController: UIViewController, MorningInterviewViewControllerInterface {

    private var currentIndex: Int = 0
    private var questions: [MorningInterview.Question] = []
    private var previousCounter: Int = 0
    var interactor: MorningInterviewInteractorInterface?
    var router: MorningInterviewRouterInterface?

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var dialPlaceholder: UIView!
    @IBOutlet private weak var leftAnswerLabel: UILabel!
    @IBOutlet private weak var rightAnswerLabel: UILabel!

    private var isFirstPage: Bool {
        return currentIndex <= 0
    }

    private var isLastPage: Bool {
        return currentIndex >= questions.count - 1
    }

    init(configurator: Configurator<MorningInterviewViewController>) {
        super.init(nibName: nil, bundle: nil)
        configurator(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.registerDequeueable(MorningInterviewCell.self)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        setupLayout()
        syncViews()
        interactor?.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.setStatusBarStyle(.lightContent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func didTapClose(_ sender: UIButton) {
        router?.close()
    }

    func setQuestions(_ questions: [MorningInterview.Question]) {
        self.questions = questions
        currentIndex = 0
        collectionView.reloadData()
        syncViews()
    }

    @IBAction func didTapPrevious(_ sender: UIButton) {
        guard isFirstPage == false else {
            assertionFailure("Tried to go back from first page")
            return
        }
        doneButton.isHidden = false
        previousCounter += 1
        currentIndex -= 1
        syncViews()
    }

    func syncViews() {
        guard questions.count > 0 else { return }
        scrollToCurrentQuestion()
        updateButtons()
        updateQuestion()
        updateLabels()
    }

    @objc func nextQuestion() {
        currentIndex += 1
        if previousCounter > 0 {
            previousCounter -= 1
        }
        syncViews()

    }

    func scrollToCurrentQuestion() {
        let index = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }

    @IBAction func didTapDone(_ sender: UIButton) {
        if isLastPage == true {
            interactor?.saveAnswers(questions: questions)
            router?.close()
        }
    }

    func updateLabels() {
        let headerLabelText = R.string.localized.morningControllerTitleLabel()
        let attributedTitle = NSMutableAttributedString(string: headerLabelText,
                                                        letterSpacing: 1.1,
                                                        font: Font.H5SecondaryHeadline,
                                                        textColor: .white,
                                                        alignment: .center)
        let progress =  " \(currentIndex + 1)\("/")\(questions.count ) "
        let progressTitle = NSMutableAttributedString(string: progress,
                                                      letterSpacing: 0,
                                                      font: Font.H5SecondaryHeadline,
                                                      textColor: .white,
                                                      alignment: .center)
        attributedTitle.append(progressTitle)
        headerLabel.attributedText = attributedTitle
        leftAnswerLabel.text = currentQuestion?.answers.first?.subtitle
        rightAnswerLabel.text = currentQuestion?.answers.last?.subtitle
    }

    func updateButtons() {
        previousButton.isHidden = isFirstPage
        if previousCounter > 0 && isLastPage == false {
            doneButton.setTitle("Next", for: .normal)
            doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            doneButton.removeTarget(self, action: #selector(didTapDone(_:)), for: .touchUpInside)
            doneButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
            doneButton.isHidden = false
        } else if isLastPage == true {
            doneButton.setTitle("Done", for: .normal)
            doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            doneButton.removeTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
            doneButton.addTarget(self, action: #selector(didTapDone(_:)), for: .touchUpInside)
            doneButton.isHidden = false
        } else if previousCounter == 0 && isLastPage == false {
            doneButton.isHidden = true
        }
    }

    func updateQuestion() {
        questionLabel.text = currentQuestion?.title
    }

    private var currentQuestion: MorningInterview.Question? {
        guard currentIndex >= 0 && currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }
}

extension MorningInterviewViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let question = questions[indexPath.item]
        let answer = question.answers[question.selectedAnswerIndex]

        let cell: MorningInterviewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(centerLabelText: answer.subtitle ?? "")
        cell.setSelected(index: question.selectedAnswerIndex)
        cell.indexDidChange = { [unowned cell] (index) in
            question.selectedAnswerIndex = index
            let answer = question.answers[question.selectedAnswerIndex]
            cell.configure(centerLabelText: answer.subtitle ?? "")
        }

        cell.didTouchUp = { (index) in
            if self.isLastPage == false {
                cell.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    cell.isUserInteractionEnabled = true
                    self.nextQuestion()
                }
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets().horizontal
    }

    private func sectionInsets() -> UIEdgeInsets {
        let padding = floor((collectionView.bounds.width - cellSize().width) / 2)
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }

    private func cellSize() -> CGSize {
        let length = floor(collectionView.bounds.height)
        return CGSize(width: length, height: length)
    }
}

private extension MorningInterviewViewController {

    func setupLayout() {
        previousButton.isHidden = true
        doneButton.isHidden = true
    }
}
