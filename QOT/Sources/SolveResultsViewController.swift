//
//  SolveResultsViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol SolveResultsViewControllerDelegate: class {
    func didFinishSolve()
}

// TODO: - Rename this scene since it's being used in Solve & 3DRecovery. Maybe somewhere else in the future..
final class SolveResultsViewController: UIViewController {

    // MARK: - Properties
    var interactor: SolveResultsInteractorInterface?
    weak var delegate: SolveResultsViewControllerDelegate?
    var isFollowUpActive = false
    private var results: SolveResults?
    @IBOutlet private weak var tableView: UITableView!

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
    func registerCells() {
        tableView.registerDequeueable(SolveHeaderTableViewCell.self)
        tableView.registerDequeueable(SolveStrategyTableViewCell.self)
        tableView.registerDequeueable(SolveTriggerTableViewCell.self)
        tableView.registerDequeueable(SolveFollowUpTableViewCell.self)
        tableView.registerDequeueable(SolveDayPlanTableViewCell.self)
        tableView.registerDequeueable(FatigueTableViewCell.self)
        tableView.registerDequeueable(CauseTableViewCell.self)
    }
}

// MARK: - Actions
private extension SolveResultsViewController {
    @objc func didTapDone() {
        switch interactor?.resultType {
        case .recovery?:
            didTapDismissButton()
        case .solve?:
            if isFollowUpActive == true {
                interactor?.save()
            } else {
                openConfirmationView()
            }
        case .none:
            return
        }
    }

    @objc func didTapDismiss() {
        switch interactor?.resultType {
        case .recovery?: didTapDismissButton()
        default: interactor?.dismiss()
        }
    }

    @objc func openConfirmationView() {
        interactor?.openConfirmationView()
    }
}

// MARK: - SolveResultsViewControllerInterface
extension SolveResultsViewController: SolveResultsViewControllerInterface {
    func setupView() {
        registerCells()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.bounds.height * 0.1, right: 0)
    }

    func load(_ results: SolveResults) {
        self.results = results
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension SolveResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch results?.items[indexPath.row] {
        case .strategy(let id, _, _, _, _)?,
             .exclusiveContent(let id, _, _, _, _)?:
            interactor?.didTapStrategy(with: id)
            trackUserEvent(.SELECT, value: id, valueType: .CONTENT, action: .TAP)
        default: return
        }
    }
}

// MARK: - UITableViewDataSource
extension SolveResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch results?.items[indexPath.row] {
        case .header(let title, let solution)?:
            let cell: SolveHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title,
                           solutionText: solution,
                           hideShowMoreButton: interactor?.hideShowMoreButton ?? false)
            cell.delegate = self
            return cell
        case .strategy(_, let title, let minsToRead, let hasHeader, let headerTitle)?:
            let cell: SolveStrategyTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(hasHeader: hasHeader, title: title, minsToRead: minsToRead, headerTitle: headerTitle)
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
        interactor?.didTapTrigger(type)
    }
}

// MARK: - SolveHeaderTableViewCellDelegate
extension SolveResultsViewController: SolveHeaderTableViewCellDelegate {
    func didTapShowMoreLess() {
        trackUserEvent(.SELECT, valueType: "SHOW MORE/LESS", action: .TAP)
        tableView.reloadData()
    }
}

// MARK: - SolveFollowUpTableViewCell
extension SolveResultsViewController: SolveFollowUpTableViewCellDelegate {
    func didTapFollowUp(isOn: Bool) {
        trackUserEvent(isOn == true ? .ENABLE : .DISABLE, action: .TAP)
        isFollowUpActive = isOn
    }
}

// MARK: - ConfirmationViewControllerDelegate
extension SolveResultsViewController: ConfirmationViewControllerDelegate {
    func didTapLeave() {
        interactor?.deleteModelAndDismiss()
    }

    func didTapStay() {
        // Do nothing.
    }
}

extension SolveResultsViewController {
    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        if interactor?.isPresentingExistingSolve() == true {
            return [dismissNavigationItem(action: #selector(didTapDismiss))]
        } else {
            return [dismissNavigationItem(action: #selector(openConfirmationView))]
        }
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return [roundedBarButtonItem(title: R.string.localized.buttonTitleSaveContinue(),
                                      buttonWidth: .DecisionTree,
                                      action: #selector(didTapDone),
                                      backgroundColor: .carbon)]
    }
}
