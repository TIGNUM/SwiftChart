//
//  ShifterResultViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ShifterResultViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties
    private lazy var router: ShifterResultRouterInterface? = ShifterResultRouter(viewController: self)
    var interactor: ShifterResultInteractorInterface?
    private var model: MindsetResult?
    @IBOutlet private weak var tableView: UITableView!

    private lazy var barButtonItemDone: UIBarButtonItem = {
        return roundedBarButtonItem(title: ScreenTitleService.main.localizedString(for: .ButtonTitleDone),
                                    buttonWidth: .Done,
                                    action: #selector(didTapDone),
                                    backgroundColor: .carbon)
    }()

    private lazy var barButtonItemSaveAndContinue: UIBarButtonItem = {
        return roundedBarButtonItem(title: ScreenTitleService.main.localizedString(for: .ButtonTitleSaveContinue),
                                    buttonWidth: .SaveAndContinue,
                                    action: #selector(didTapSave),
                                    backgroundColor: .carbon)
    }()

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
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 50.0, right: 0.0)
        tableView.registerDequeueable(MindsetShifterHeaderCell.self)
        tableView.registerDequeueable(TriggerTableViewCell.self)
        tableView.registerDequeueable(ReactionsTableViewCell.self)
        tableView.registerDequeueable(NegativeToPositiveTableViewCell.self)
        tableView.registerDequeueable(MindsetVisionTableViewCell.self)
    }
}

// MARK: - Private
private extension ShifterResultViewController {
    @objc func didTapDone() {
        trackUserEvent(.CLOSE, action: .TAP)
        router?.dismiss()
    }

    @objc func didTapSave() {
        trackUserEvent(.CONFIRM, action: .TAP)
        router?.presentFeedback()
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
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return []
    }
}
