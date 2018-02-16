//
//  MorningInterviewViewController.swift
//
//  Created by Javier Sanz Rozalen on 15/12/2017.
//  Copyright © 2017 Javier Sanz Rozalen. All rights reserved.
//

import UIKit
import Anchorage

protocol MorningInterviewViewControllerDelegate: class {

    func didTapClose(viewController: MorningInterviewViewController, userAnswers: [UserAnswer], notificationRemoteID: Int)
}

class MorningInterviewViewController: UIViewController {

    weak var delegate: MorningInterviewViewControllerDelegate?
    private var currentIndex: Int = 0
    private let viewModel: MorningInterviewViewModel
    private var question: InterviewQuestion?
    private var userAnswers: [UserAnswer]?

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var dialPlaceholder: UIView!
    @IBOutlet weak var leftAnswerLabel: UILabel!
    @IBOutlet weak var rightAnswerLabel: UILabel!

    private var isFirstPage: Bool {
        return currentIndex <= 0
    }

    private var isLastPage: Bool {
        return currentIndex >= viewModel.questionsCount - 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerDequeueable(MorningInterviewCell.self)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        setupLayout()
        syncViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    init(viewModel: MorningInterviewViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func didTapClose(_ sender: UIButton) {
        delegate?.didTapClose(viewController: self,
                              userAnswers: [],
                              notificationRemoteID: viewModel.notificationRemoteID)
    }

    @IBAction func didTapPrevious(_ sender: UIButton) {
        guard isFirstPage == false else {
            assertionFailure("Tried to go back from first page")
            return
        }

        currentIndex -= 1
        syncViews()
    }

    func syncViews() {
        scrollToCurrentQuestion()
        updateButtons()
        updateQuestion()
        updateLabels()
    }

    func scrollToCurrentQuestion() {
        let index = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }

    @IBAction func didTapDone(_ sender: UIButton) {
        if isLastPage == true {
            userAnswers = viewModel.createUserAnswers()
            if let answers = userAnswers {
                try? viewModel.save(userAnswers: answers)
                delegate?.didTapClose(viewController: self,
                                      userAnswers: answers,
                                      notificationRemoteID: viewModel.notificationRemoteID)
            }
        } else {
            currentIndex += 1
            syncViews()
        }
    }

    func updateLabels() {
        let headerLabelText = R.string.localized.morningControllerTitleLabel()
        let attributedTitle = NSMutableAttributedString(
            string: headerLabelText,
            letterSpacing: 1.1,
            font: Font.H5SecondaryHeadline,
            textColor: .white,
            alignment: .center
        )
        let progress =  " \(currentIndex + 1)\("/")\(viewModel.questionsCount ) "
        let progressTitle = NSMutableAttributedString(
            string: progress,
            letterSpacing: 0,
            font: Font.H5SecondaryHeadline,
            textColor: .white,
            alignment: .center
        )
        attributedTitle.append(progressTitle)
        headerLabel.attributedText = attributedTitle
        leftAnswerLabel.text = question?.answers.first?.subtitle
        rightAnswerLabel.text = question?.answers.last?.subtitle
    }

    func updateButtons() {
        let doneButtonTitle = isLastPage ? R.string.localized.morningControllerDoneButton() : R.string.localized.morningControllerNextButton()
        doneButton.setTitle(doneButtonTitle, for: .normal)
        previousButton.isHidden = isFirstPage
    }

    func updateQuestion() {
        question = viewModel.question(at: currentIndex)
        questionLabel.text = question?.title
    }
}

extension MorningInterviewViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.questionsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let question = viewModel.question(at: indexPath.item)
        let cell: MorningInterviewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(centerLabelText: question.currentAnswer.subtitle ?? "")
        cell.setSelected(index: question.answerIndex)
        cell.indexDidChange = { [unowned cell] (index) in
            question.answerIndex = index
            cell.configure(centerLabelText: question.currentAnswer.subtitle ?? "")
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
        
        
//        answerLabel.font = Font.H5SecondaryHeadlinex
//        oneLabel.font = Font.H5SecondaryHeadline
//        tenLabel.font = Font.H5SecondaryHeadline
//        qualityTitleLabel.font = Font.H5SecondaryHeadline
//        qualityTitleLabel.text = "QUALITY"
//        qualityTitleLabel.isHidden = true
//
//        answerLabel.numberOfLines = 0
//        answerLabel.layer.cornerRadius = 2
//        answerLabel.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)
//        answerLabel.layer.shadowOpacity = 0.7
//        answerLabel.layer.masksToBounds = false
    }
}
