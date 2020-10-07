//
//  DTQuestionnaireViewController.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum CellType: Int, CaseIterable {
    case question
    case answer
}

protocol DTQuestionnaireViewControllerDelegate: class {
    func didTapBinarySelection(_ answer: DTViewModel.Answer)
    func didSelectAnswer(_ answer: DTViewModel.Answer)
    func didDeSelectAnswer(_ answer: DTViewModel.Answer)
    func didSelectExistingPreparation(_ qdmPreparation: QDMUserPreparation?)
}

class DTQuestionnaireViewController: BaseViewController {

    // MARK: - Properties
    private let viewModel: DTViewModel
    weak var delegate: DTQuestionnaireViewControllerDelegate?
    var interactor: DTInteractorInterface!
    private lazy var tableView = UITableView(estimatedRowHeight: 100,
                                             delegate: self,
                                             dataSource: self,
                                             dequeables: MultipleSelectionTableViewCell.self,
                                             SingleSelectionTableViewCell.self,
                                             QuestionTableViewCell.self,
                                                 AnimatedAnswerTableViewCell.self,
                                             TextTableViewCell.self,
                                             ExistingPreparationTableViewCell.self,
                                             PollTableViewCell.self,
                                             UserInputTableViewCell.self)
    private var constraintTableHeight: NSLayoutConstraint?
    private var observers: [NSKeyValueObservation] = []
    private var heightOfCollection: CGFloat = 0.0
    private var shouldWaitFotTBVAnimationCompleted = false

    // MARK: - Init
    init(viewModel: DTViewModel) {
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
        checkScroll()
        tableView.bounces = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if tableView.isScrollEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.tableView.flashScrollIndicators()
            }
        }
    }

    func contentOffset() -> CGPoint {
        return tableView.contentOffset
    }
}

// MARK: - Private
private extension DTQuestionnaireViewController {
    func setupView() {
        let theme: ThemeView = (interactor.isDark) ? .chatbotDark : .chatbot
        theme.apply(view)
        tableView.contentInset = .zero      //this takes off an automatic 49.0 pixel top inset that is not needed
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.clipsToBounds = false
        attachTableView()
        observers = [tableView.observe(\.contentSize, options: [.new]) { [weak self] (tableView, change) in
            self?.checkScroll()
            }
        ]
        attachBottomShadow()
        shouldWaitFotTBVAnimationCompleted = viewModel.hasTypingAnimation && viewModel.tbvText != nil
    }

    func checkScroll() {
        constraintTableHeight?.constant = tableView.contentSize.height
        tableView.setNeedsUpdateConstraints()
        tableView.isScrollEnabled = tableView.contentSize.height > tableView.bounds.height
    }

    func attachTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.BottomNavBar).isActive = true
        tableView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        let constraintHeight = NSLayoutConstraint(item: tableView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .height,
                                                  multiplier: 1.0,
                                                  constant: 0.0)
        tableView.addConstraint(constraintHeight)
        constraintTableHeight = constraintHeight
    }

    func attachBottomShadow() {
        let isDark = interactor.isDark
        let imageView = UIImageView(image: isDark ? R.image.darkBottomGradient() : R.image.lightBottomGradient())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.addConstraint(NSLayoutConstraint(item: imageView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .height,
                                              multiplier: 1,
                                              constant: imageView.image?.size.height ?? 0.0))
    }
}

// MARK: - UITableViewDelegate
extension DTQuestionnaireViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = CellAnimator.moveUpWithFade(rowHeight: cell.frame.height, duration: 0.01, delayFactor: 0.05)
        let animator = CellAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension DTQuestionnaireViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return CellType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = CellType.allCases[indexPath.section]
        switch type {
        case .question:
            let cell: QuestionTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(with: viewModel.question.title,
                           html: viewModel.question.htmlTitleString,
                           questionUpdate: nil,
                           textColor: (interactor.isDark) ? .sand : .carbon)
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
                if viewModel.question.key == Prepare.QuestionKey.SelectExisting {
                    return getExistingPreparationCell(indexPath, tableView)
                }
                return getSelectionCell(indexPath, tableView)
            case .poll:
                return getPollCell(indexPath, tableView)
            case .text:
                if viewModel.hasTypingAnimation {
                    return getTypingCell(indexPath, tableView, title: viewModel.tbvText ?? "")
                }
                let cell: TextTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(with: viewModel.tbvText ?? "",
                               textColor: (interactor.isDark) ? .sand : .carbon)
                return cell

            case .noAnswerRequired,
                 .onlyExistingAnswer:
                if let answer = viewModel.answers.first, viewModel.hasTypingAnimation {
                    return getTypingCell(indexPath, tableView, title: viewModel.tbvText ?? answer.title)
                }
            case .userInput:
                let cell: UserInputTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(questionKey: viewModel.question.key,
                               inputText: viewModel.userInputText,
                               maxCharacters: QuestionKey.maxCharacter(viewModel.question.key),
                               delegate: self)
                return cell
            default:
                break
            }
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Private
private extension DTQuestionnaireViewController {
    func getTypingCell(_ indexPath: IndexPath, _ tableView: UITableView, title: String?) -> AnimatedAnswerTableViewCell {
        let cell: AnimatedAnswerTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: title ?? "",
                       html: nil,
                       questionUpdate: nil,
                       textColor: (interactor.isDark) ? .sand : .carbon,
                       animateTextDuration: viewModel.typingAnimationDuration)
        cell.delegate = self
        return cell
    }

    func getExistingPreparationCell(_ indexPath: IndexPath, _ tableView: UITableView) -> ExistingPreparationTableViewCell {
        let cell: ExistingPreparationTableViewCell = tableView.dequeueCell(for: indexPath)
        let tableViewHeight = view.frame.height - (cell.frame.height + 64)
        interactor.getCriticalPreparations { (preparations) in
            cell.configure(tableViewHeight: tableViewHeight, preparations: preparations)
        }
        cell.delegate = delegate
        return cell
    }

    func getSelectionCell(_ indexPath: IndexPath, _ tableView: UITableView) -> MultipleSelectionTableViewCell {
        let cell: MultipleSelectionTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(for: viewModel.answers,
                       maxPossibleSelections: viewModel.question.maxSelections,
                       collectionHeight: heightOfCollection)
        cell.delegate = self
        return cell
    }

    func getPollCell(_ indexPath: IndexPath, _ tableView: UITableView) -> PollTableViewCell {
        let cell: PollTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(for: viewModel.answers,
                       maxPossibleSelections: viewModel.question.maxSelections,
                       collectionHeight: heightOfCollection)
        cell.delegate = self
        return cell
    }
}

// MARK: - SingleSelectionCellDelegate
extension DTQuestionnaireViewController: SingleSelectionCellDelegate {
    func didSelect(_ answer: DTViewModel.Answer) {
        delegate?.didTapBinarySelection(answer)
    }
}

// MARK: - MultiselectionCellDelegate
extension DTQuestionnaireViewController: MultipleSelectionCellDelegate {
    func didSetHeight(to height: CGFloat) {
        let setBefore = heightOfCollection != 0
        heightOfCollection = height
        if !setBefore {
            tableView.reloadData()
        }
    }

    func didSelectAnswer(_ answer: DTViewModel.Answer) {
        delegate?.didSelectAnswer(answer)
    }

    func didDeSelectAnswer(_ answer: DTViewModel.Answer) {
        delegate?.didDeSelectAnswer(answer)
    }
}

// MARK: - QuestionCellDelegate
extension DTQuestionnaireViewController: AnimatedAnswerCellDelegate {
    func didFinishTypeAnimation() {
        if let answer = viewModel.answers.first {
            if viewModel.tbvText?.isEmpty == false || !answer.title.isEmpty {
                interactor.didStopTypingAnimation()

                UIView.animate(withDuration: 0.25, animations: {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                    self.checkScroll()
                })
            } else {
                interactor.didStopTypingAnimationPresentNextPage(viewModel: viewModel)
            }
        } else {
            interactor.didStopTypingAnimation()
        }
    }
}

// MARK: UserInputTableViewCellProtocol
extension DTQuestionnaireViewController: UserInputTableViewCellProtocol {
    func didUpdateUserInput(_ text: String, questionKey: String) {
        interactor.didUpdateUserInput(text, questionKey: questionKey)
    }
}
