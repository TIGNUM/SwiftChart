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

final class SolveResultsViewController: UIViewController {

    // MARK: - Properties

    var interactor: SolveResultsInteractorInterface?
    weak var delegate: SolveResultsViewControllerDelegate?
    private var isFollowUpActive = false
    private var results: SolveResults?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var doneButton: UIButton!

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
        setupView()
        registerCells()
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
    }

    func setupView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.bounds.height * 0.1, right: 0)
        doneButton.corner(radius: doneButton.frame.height / 2)
    }
}

// MARK: - Actions

private extension SolveResultsViewController {

    @IBAction func didTapDone(_ sender: UIButton) {
        if isFollowUpActive == true {
            interactor?.save()
        } else {
            interactor?.openConfirmationView()
        }
    }
}

// MARK: - SolveResultsViewControllerInterface

extension SolveResultsViewController: SolveResultsViewControllerInterface {

    func load(_ results: SolveResults) {
        self.results = results
    }
}

// MARK: - UITableViewDelegate

extension SolveResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch results?.items[indexPath.row] {
        case .strategy(let id, _, _, _)?:
            interactor?.didTapStrategy(with: id)
            trackUserEvent(.SELECT, value: id, valueType: QDMUserEventTracking.ValueType.CONTENT, action: .TAP)
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
            cell.configure(title: title, solutionText: solution)
            cell.delegate = self
            return cell
        case .strategy(_, let title, let minsToRead, let hasHeader)?:
            let cell: SolveStrategyTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(hasHeader: hasHeader, title: title, minsToRead: minsToRead)
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
            cell.configure(title: title, description: subtitle)
            cell.delegate = self
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
        dismiss(animated: true, completion: {
            self.delegate?.didFinishSolve()
        })
    }

    func didTapStay() {
        // Do nothing.
    }
}
