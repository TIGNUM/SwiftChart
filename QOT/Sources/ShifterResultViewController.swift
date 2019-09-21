//
//  ShifterResultViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ShifterResultViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: ShifterResultInteractorInterface?
    private var model: MindsetResult?
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Init
    init(configure: Configurator<ShifterResultViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.chatbot.apply(view)
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - ShifterResultViewControllerInterface
extension ShifterResultViewController: ShifterResultViewControllerInterface {
    func load(_ model: MindsetResult) {
        self.model = model
        tableView.reloadData()
    }

    func setupView() {
        registerCells()
    }
}

// MARK: - Private
private extension ShifterResultViewController {
    func registerCells() {
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 50.0, right: 0.0)
        tableView.registerDequeueable(MindsetShifterHeaderCell.self)
        tableView.registerDequeueable(TriggerTableViewCell.self)
        tableView.registerDequeueable(ReactionsTableViewCell.self)
        tableView.registerDequeueable(NegativeToPositiveTableViewCell.self)
        tableView.registerDequeueable(MindsetVisionTableViewCell.self)
    }
}

// MARK: - Actions
private extension ShifterResultViewController {
    @objc func didTapSave() {
        trackUserEvent(.CONFIRM, action: .TAP)
        interactor?.presentFeedback()
    }

    @objc func openConfirmationView() {
        trackUserEvent(.CONFIRM, action: .TAP)
        interactor?.didTapClose()
    }
}

// MARK: - UITableViewDelegate
extension ShifterResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch model?.sections[indexPath.row] {
        default: return
        }
    }
}

// MARK: - UITableViewDataSource
extension ShifterResultViewController: UITableViewDataSource {
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
        case .lowToHigh(let title, let lowTitle, let lowItems, let highTitle, let highItems)?:
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

// MARK: - BottomNavigation Items
extension ShifterResultViewController {
    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItem(action: #selector(openConfirmationView))]
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return [roundedBarButtonItem(title: model?.buttonTitle ?? R.string.localized.buttonTitleSaveContinue(),
                                     buttonWidth: .DecisionTree,
                                     action: #selector(didTapSave),
                                     backgroundColor: .carbonDark)]
    }
}
