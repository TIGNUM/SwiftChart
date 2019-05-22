//
//  MindsetShifterChecklistViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MindsetShifterChecklistViewController: UIViewController {

    // MARK: - Properties

    var interactor: MindsetShifterChecklistInteractorInterface?
    private var model: MindsetShifterChecklistModel?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var confirmationButton: UIButton!

    // MARK: - Init

    init(configure: Configurator<MindsetShifterChecklistViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        registerCells()
        setupView()
    }
}

// MARK: - MindsetShifterChecklistViewControllerInterface

extension MindsetShifterChecklistViewController: MindsetShifterChecklistViewControllerInterface {

    func load(_ model: MindsetShifterChecklistModel) {
        self.model = model
    }
}

// MARK: - Private

private extension MindsetShifterChecklistViewController {

    func setupView() {
        tableView.backgroundColor = .sand
        confirmationButton.corner(radius: confirmationButton.bounds.height / 2)
        confirmationButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        confirmationButton.layer.shadowColor = UIColor.lightGray.cgColor
        confirmationButton.layer.shadowOpacity = 1
        confirmationButton.layer.shadowRadius = 5
        confirmationButton.layer.masksToBounds = false
        confirmationButton.setTitle(model?.buttonTitle, for: .normal)
    }

    func registerCells() {
        tableView?.registerDequeueable(MindsetShifterHeaderCell.self)
        tableView?.registerDequeueable(TriggerTableViewCell.self)
        tableView?.registerDequeueable(ReactionsTableViewCell.self)
        tableView?.registerDequeueable(NegativeToPositiveTableViewCell.self)
        tableView?.registerDequeueable(MindsetVisionTableViewCell.self)
    }
}

// MARK: - Actions

private extension MindsetShifterChecklistViewController {

    @IBAction func didTapClose(_ sender: UIButton) {
        interactor?.didTapClose()
    }

    @IBAction func didTapSave(_ sender: UIButton) {
        interactor?.didTapSave()
    }
}

// MARK: - UITableViewDelegate

extension MindsetShifterChecklistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch model?.sections[indexPath.row] {
        default: return
        }
    }
}

// MARK: - UITableViewDataSource

extension MindsetShifterChecklistViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.sections.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch model?.sections[indexPath.row] {
        case .header(let title, let subtitle)?:
            let cell: MindsetShifterHeaderCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, subtitle: subtitle)
            return cell
        case .trigger(let title, let subtitle)?:
            let cell: TriggerTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, triggerItem: subtitle)
            return cell
        case .reactions(let title, let items)?:
            let cell: ReactionsTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, reactions: items)
            return cell
        case .fromNegativeToPositive(let title, let lowTitle, let lowItems, let highTitle, let highItems)?:
            let cell: NegativeToPositiveTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, lowTitle: lowTitle, lowItems: lowItems, highTitle: highTitle, highItems: highItems)
            return cell
        case .vision(let title, let text)?:
            let cell: MindsetVisionTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, vision: text)
            return cell
        default: preconditionFailure()
        }
    }
}
