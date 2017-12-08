//
//  ViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/28/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol MorningInterviewViewControllerDelegate: class {

    func didTapClose(viewController: MorningInterviewViewController, userAnswers: [UserAnswer])
}

final class MorningInterviewViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: MorningInterviewViewControllerDelegate?
    private var currentIndex: Int = 0
    private let viewModel: MorningInterviewViewModel
    private let topView = UIView()
    private let bottomView = UIView()
    private var headerLabel = UILabel()

    private lazy var blurView: UIVisualEffectView = {
        var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectView.frame = self.view.frame

        return blurEffectView
    }()

    private var isFirstPage: Bool {
        return currentIndex <= 0
    }

    private var isLastPage: Bool {
        return currentIndex >= viewModel.questionsCount - 1
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        return UICollectionView(
            layout: layout,
            delegate: self,
            dataSource: self,
            dequeables: MorningInterviewCell.self
        )
    }()

    private var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.localized.morningControllerNextButton(), for: UIControlState.normal)
        button.titleLabel?.font = Font.DPText
        button.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
        button.setTitleColor(.white40, for: .normal)

        return button
    }()

    private var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.ic_back(), for: UIControlState.normal)
        button.addTarget(self, action: #selector(didTapPrevious(_:)), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true

        return button
    }()

    private var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.ic_close(), for: UIControlState.normal)
        button.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)

        return button
    }()

    @objc func didTapNext(_ sender: UIButton) {
        if isLastPage == true {
            let userAnswers = viewModel.createUserAnswers()
            delegate?.didTapClose(viewController: self, userAnswers: userAnswers)
            try? viewModel.save(userAnswers: userAnswers)
        } else {
            currentIndex += 1
            syncViews(animated: true)
        }
    }

    @objc func didTapPrevious(_ sender: UIButton) {
        guard isFirstPage == false else {
            assertionFailure("Tried to go back from first page")
            return
        }

        currentIndex -= 1
        syncViews(animated: true)
    }

    @objc func didTapClose(_ sender: UIButton) {
        delegate?.didTapClose(viewController: self, userAnswers: [])
    }

    func syncViews(animated: Bool) {
        scrollToCurrentQuestion(animated: animated)
        updateHeaderLabel()
        updateButtons()
    }

    func scrollToCurrentQuestion(animated: Bool) {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func updateHeaderLabel() {
        let text = R.string.localized.morningControllerTitleLabel()
        let attributedTitle = NSMutableAttributedString(
            string: text,
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
        headerLabel.textAlignment = .center
    }

    func updateButtons() {
        let nextButtonTitle = isLastPage ? R.string.localized.morningControllerDoneButton() : R.string.localized.morningControllerNextButton()
        nextButton.setTitle(nextButtonTitle, for: .normal)
        leftButton.isHidden = currentIndex <= 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.isScrollEnabled = false
        setupHierarchy()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.statusBarStyle = .lightContent
        syncViews(animated: false)
    }

    init(viewModel: MorningInterviewViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MorningInterviewViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: Public CollectionView data source

extension MorningInterviewViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.questionsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let question = viewModel.question(at: indexPath.item)
        let cell: MorningInterviewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(question: question)
        return cell
    }
}

private extension MorningInterviewViewController {

    func setupHierarchy() {
        view.addSubview(blurView)
        blurView.contentView.addSubview(topView)
        topView.addSubview(leftButton)
        topView.addSubview(closeButton)
        topView.addSubview(headerLabel)
        blurView.contentView.addSubview(collectionView)
        blurView.contentView.addSubview(bottomView)
        bottomView.addSubview(nextButton)
    }

    func setupLayout() {
        topView.topAnchor == view.safeTopAnchor + 24
        topView.horizontalAnchors == view.horizontalAnchors
        topView.heightAnchor == 30

        leftButton.verticalAnchors == topView.verticalAnchors
        leftButton.leftAnchor == topView.leftAnchor + 5
        leftButton.widthAnchor == 36

        headerLabel.leftAnchor == leftButton.rightAnchor
        headerLabel.rightAnchor == closeButton.leftAnchor
        headerLabel.verticalAnchors == topView.verticalAnchors

        closeButton.verticalAnchors == topView.verticalAnchors
        closeButton.rightAnchor == topView.rightAnchor
        closeButton.widthAnchor == 36
        closeButton.leftAnchor == headerLabel.rightAnchor

        collectionView.topAnchor == topView.bottomAnchor
        collectionView.horizontalAnchors == view.horizontalAnchors
        collectionView.bottomAnchor == view.bottomAnchor - 69

        bottomView.topAnchor == collectionView.bottomAnchor
        bottomView.bottomAnchor == view.bottomAnchor
        bottomView.leadingAnchor == view.leadingAnchor
        bottomView.trailingAnchor == view.trailingAnchor

        nextButton.leadingAnchor == bottomView.leadingAnchor
        nextButton.trailingAnchor == bottomView.trailingAnchor
        nextButton.topAnchor == bottomView.topAnchor
        nextButton.bottomAnchor == bottomView.bottomAnchor

        view.layoutIfNeeded()
    }
}
