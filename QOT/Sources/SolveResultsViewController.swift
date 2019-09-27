//
//  SolveResultsViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

// TODO: - Rename this scene since it's being used in Solve & 3DRecovery. Maybe somewhere else in the future..
final class SolveResultsViewController: BaseWithTableViewController, ScreenZLevel3 {

    // MARK: - Properties
    private lazy var router: SolveResultsRouterInterface? = SolveResultsRouter(viewController: self)
    var interactor: SolveResultsInteractorInterface?
    var resultDelegate: DTRouterInterface?
    private var rightBarItems: [UIBarButtonItem] = []
    private var resultViewModel: SolveResult?
    private var isFollowUpActive = true

    // MARK: - Init
    init(configure: Configurator<SolveResultsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - Private
private extension SolveResultsViewController {
    @objc func didTapDone() {
        trackUserEvent(.CLOSE, action: .TAP)
        switch interactor?.resultType {
        case .recoveryDecisionTree?,
             .recoveryMyPlans?: router?.dismiss()
        case .solveDailyBrief?,
             .solveDecisionTree?: handleDidTapDoneSolve()
        default: break
        }
    }

    @objc func didTapCancel() {
        trackUserEvent(.CANCEL, action: .TAP)
        interactor?.deleteRecovery()
        resultDelegate?.goBackToSolveResult()
    }

    @objc func didTapSave() {
        trackUserEvent(.CONFIRM, action: .TAP)
        router?.presentFeedback()
    }

    func handleDidTapDoneSolve() {
        switch (resultViewModel?.type, isFollowUpActive) {
        case (.solveDecisionTree?, true): saveSolveAndDismiss()
        case (.solveDecisionTree?, false): showAlert()
        case (.solveDailyBrief?, false): showAlert()
        case (.solveDailyBrief?, true): router?.dismiss()
        default: return
        }
    }

    func saveSolveAndDismiss() {
        interactor?.save(solveFollowUp: isFollowUpActive)
        router?.dismiss()
    }

    func showAlert() {
        let activate = QOTAlertAction(title: R.string.localized.solveLeaveAlertActivate()) { [weak self] _ in
            self?.isFollowUpActive = true
            if self?.resultViewModel?.type == .solveDecisionTree {
                self?.saveSolveAndDismiss()
            } else {
                self?.router?.dismiss()
            }
        }
        let leave = QOTAlertAction(title: R.string.localized.solveLeaveAlertContinueButton()) { [weak self] _ in
            self?.saveSolveAndDismiss()
        }
        QOTAlert.show(title: R.string.localized.solveLeaveAlertTitle(),
                      message: R.string.localized.solveLeaveAlertMessage(),
                      bottomItems: [activate, leave])
    }

    func setupBarButtonItems(resultType: ResultType) {
        resultType.buttonItems.forEach { (buttonItem) in
            rightBarItems.append(roundedBarButtonItem(title: buttonItem.title,
                                                      buttonWidth: buttonItem.width,
                                                      action: getSelector(buttonItem),
                                                      backgroundColor: buttonItem.backgroundColor,
                                                      borderColor: buttonItem.borderColor))
        }
        updateBottomNavigation([], rightBarItems)
    }

    func getSelector(_ buttonItem: ButtonItem) -> Selector {
        switch buttonItem {
        case .cancel: return #selector(didTapCancel)
        case .done: return #selector(didTapDone)
        case .save: return #selector(didTapSave)
        }
    }
}

// MARK: - SolveResultsViewControllerInterface
extension SolveResultsViewController: SolveResultsViewControllerInterface {
    func setupView() {
        tableView.registerDequeueable(SolveHeaderTableViewCell.self)
        tableView.registerDequeueable(SolveStrategyTableViewCell.self)
        tableView.registerDequeueable(SolveTriggerTableViewCell.self)
        tableView.registerDequeueable(SolveFollowUpTableViewCell.self)
        tableView.registerDequeueable(SolveDayPlanTableViewCell.self)
        tableView.registerDequeueable(FatigueTableViewCell.self)
        tableView.registerDequeueable(CauseTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.bounds.height * 0.1, right: 0)
    }

    func load(_ resultViewModel: SolveResult, isFollowUpActive: Bool) {
        self.isFollowUpActive = isFollowUpActive
        self.resultViewModel = resultViewModel
        tableView.reloadData()
        setupBarButtonItems(resultType: resultViewModel.type)
    }
}

// MARK: - UITableViewDelegate
extension SolveResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
        switch resultViewModel?.items[indexPath.row] {
        case .strategy(let id, _, _, _, _)?,
             .exclusiveContent(let id, _, _, _, _)?:
            router?.openStrategy(with: id)
            if let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(id)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            }
            trackUserEvent(.SELECT, value: id, valueType: .CONTENT, action: .TAP)
        default:
            tableView.isUserInteractionEnabled = true
            return
        }
    }
}

// MARK: - UITableViewDataSource
extension SolveResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultViewModel?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch resultViewModel?.items[indexPath.row] {
        case .header(let title, let solution)?:
            let cell: SolveHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, solutionText: solution)
            cell.delegate = self
            return cell
        case .strategy(_, let title, let minsToRead, let hasHeader, let headerTitle)?:
            let cell: SolveStrategyTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(hasHeader: hasHeader, title: title.uppercased(), minsToRead: minsToRead, headerTitle: headerTitle)
            return cell
        case .trigger(let type, let header, let description, let buttonText)?:
            let cell: SolveTriggerTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(type: type, header: header, description: description, buttonText: buttonText)
            cell.delegate = self
            return cell
        case .fiveDayPlay(let hasHeader, let text)?:
            let cell: SolveDayPlanTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(hasHeader: hasHeader, with: text)
            return cell
        case .followUp(let title, let subtitle)?:
            let cell: SolveFollowUpTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, description: subtitle, isFollowUp: isFollowUpActive)
            cell.delegate = self
            return cell
        case .cause(let cause, let explanation)?:
            let cell: CauseTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(cause: cause, explanation: explanation)
            return cell
        case .exclusiveContent(_, let hasHeader, let title, let minsToRead, let headerTitle)?:
            let cell: SolveStrategyTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(hasHeader: hasHeader, title: title, minsToRead: minsToRead, headerTitle: headerTitle)
            cell.backgroundColor = UIColor(red: 232.0 / 225.0, green: 227.0 / 225.0, blue: 224.0 / 225.0, alpha: 1)
            return cell
        case .fatigue(let symptom)?:
            let cell: FatigueTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(symptom: symptom)
            return cell
        default: preconditionFailure()
        }
    }
}

// MARK: - SolveTriggerTableViewCellDelegate
extension SolveResultsViewController: SolveTriggerTableViewCellDelegate {
    func didTapStart(_ type: SolveTriggerType) {
        trackUserEvent(.SELECT, valueType: "START \(type.rawValue)", action: .TAP)
        interactor?.save(solveFollowUp: isFollowUpActive)
        switch type {
        case .midsetShifter: router?.openMindsetShifter()
        case .recoveryPlaner: router?.openRecovery()
        default: break
        }
    }
}

// MARK: - SolveHeaderTableViewCellDelegate
extension SolveResultsViewController: SolveHeaderTableViewCellDelegate {
    func didTapShowMoreLess() {
        trackUserEvent(.SELECT, valueType: "SHOW MORE/LESS", action: .TAP)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - SolveFollowUpTableViewCellDelegate
extension SolveResultsViewController: SolveFollowUpTableViewCellDelegate {
    func didTapFollowUp(isOn: Bool) {
        trackUserEvent(isOn == true ? .ENABLE : .DISABLE, action: .TAP)
        isFollowUpActive = isOn
    }
}

extension SolveResultsViewController {
    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return rightBarItems
    }
}
