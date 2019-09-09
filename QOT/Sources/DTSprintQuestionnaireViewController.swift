//
//  DTSprintQuestionnaireViewController.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol DTSprintQuestionnaireViewControllerDelegate: class {
    func didTapBinarySelection(_ answer: ViewModel.Answer)
    func didSelectAnswer(_ answer: ViewModel.Answer)
    func didDeSelectAnswer(_ answer: ViewModel.Answer)
}

class DTSprintQuestionnaireViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: ViewModel
    weak var delegate: DTSprintQuestionnaireViewControllerDelegate?
    var interactor: DTSprintInteractorInterface?
    private lazy var typingAnimation = DotsLoadingView(frame: CGRect(x: 24, y: 0, width: 20, height: .TypingFooter))
    private lazy var tableView = UITableView(estimatedRowHeight: 100,
                                             delegate: self,
                                             dataSource: self,
                                             dequeables: MultipleSelectionTableViewCell.self,
                                             SingleSelectionTableViewCell.self,
                                             QuestionTableViewCell.self,
                                             TextTableViewCell.self,
                                             CalendarEventsTableViewCell.self,
                                             UserInputTableViewCell.self)
    private var constraintTableHeight: NSLayoutConstraint?
    private var observers: [NSKeyValueObservation] = []
    private var heightOfCollection: CGFloat = 0.0

    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

private extension DTSprintQuestionnaireViewController {
    func setupView() {
        ThemeView.chatbot.apply(view)
        tableView.contentInset = .zero      //this takes off an automatic 49.0 pixel top inset that is not needed
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.clipsToBounds = false
        attachTableView()
        observers = [tableView.observe(\.contentSize, options: [.new]) { [weak self] (tableView, change) in
            guard let tableView = self?.tableView,
                let view = self?.view ,
                let constraintHeight = self?.constraintTableHeight else { return }
            constraintHeight.constant = tableView.contentSize.height
            tableView.setNeedsUpdateConstraints()
            tableView.isScrollEnabled = tableView.contentSize.height > view.bounds.height
            }
        ]
        attachBottomShadow()
    }

    func typingAnimationStart() {
        guard viewModel.hasTypingAnimation else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + Animation.duration_3) { [weak self] in
            self?.tableView.scrollToBottom(animated: true)
            self?.typingAnimation.alpha = 1
            self?.typingAnimation.startAnimation(withDuration: Animation.duration_3) {
                self?.interactor?.didStopTypingAnimation(answer: self?.viewModel.answers.first)
            }
        }
    }

    func attachTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.BottomNavBar).isActive = true
        tableView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        let constraintHeight = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.0)
        tableView.addConstraint(constraintHeight)
        constraintTableHeight = constraintHeight
    }

    func attachBottomShadow() {
        let imageView = UIImageView(image: R.image.lightBottomGradient())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: imageView.image?.size.height ?? 0.0))
    }
}

// MARK: - UITableViewDelegate
extension DTSprintQuestionnaireViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = CellAnimator.moveUpWithFade(rowHeight: cell.frame.height, duration: 0.01, delayFactor: 0.05)
        let animator = CellAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = CellType.allCases[indexPath.section]
        switch type {
        case .question:
            return UITableViewAutomaticDimension
        case .answer:
            switch viewModel.question.answerType {
            case .yesOrNo,
                 .singleSelection,
                 .multiSelection:
                return UITableViewAutomaticDimension
            default:
                return 0.0
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension DTSprintQuestionnaireViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return CellType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        // Display data
        let type = CellType.allCases[indexPath.section]
        switch type {
        case .question:
            let cell: QuestionTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(with: viewModel.question.title,
                           html: nil,
                           questionTitleUpdate: nil,
                           textColor: .carbon)
            return cell
        case .answer:
            switch viewModel.question.answerType {
            case .yesOrNo,
                 .uploadImage:
                let cell: SingleSelectionTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(for: viewModel.answers.first, leftAnswer: viewModel.answers.last)
                cell.delegate = self
                return cell
            case .singleSelection,
                 .multiSelection:
                let cell: MultipleSelectionTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(for: viewModel.answers, maxPossibleSelections: viewModel.question.maxSelections, collectionHeight: heightOfCollection)
                cell.delegate = self
                return cell
            default:
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == CellType.question.rawValue && viewModel.hasTypingAnimation ? .TypingFooter : 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == CellType.question.rawValue && viewModel.hasTypingAnimation {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: .TypingFooter))
            footer.addSubview(typingAnimation)
            typingAnimation.configure(dotsColor: .carbonNew)
            typingAnimation.alpha = 0
            typingAnimationStart()
            return footer
        }
        return nil
    }
}

// MARK: - SingleSelectionCellDelegate
extension DTSprintQuestionnaireViewController: SingleSelectionCellDelegate {
    func didSelect(_ answer: ViewModel.Answer) {
        delegate?.didTapBinarySelection(answer)
    }
}

// MARK: - MultiselectionCellDelegate
extension DTSprintQuestionnaireViewController: MultipleSelectionCellDelegate {
    func didSetHeight(to height: CGFloat) {
        let setBefore = heightOfCollection != 0
        heightOfCollection = height
        if !setBefore {
            tableView.reloadData()
        }
    }

    func didSelectAnswer(_ answer: ViewModel.Answer) {
        delegate?.didSelectAnswer(answer)
    }

    func didDeSelectAnswer(_ answer: ViewModel.Answer) {
        delegate?.didDeSelectAnswer(answer)
    }
}
