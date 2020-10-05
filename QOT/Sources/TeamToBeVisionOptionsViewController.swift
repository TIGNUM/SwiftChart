//
//  TeamToBeVisionOptionsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

protocol TeamToBeVisionOptionsViewControllerDelegate: class {
    func showAlert()
}

final class TeamToBeVisionOptionsViewController: BaseViewController, ScreenZLevel2 {

    enum ActionType: Int {
        case rate = 0
        case end
    }

    // MARK: - Properties
    var interactor: TeamToBeVisionOptionsInteractorInterface!
    private lazy var router: TeamToBeVisionOptionsRouterInterface = TeamToBeVisionOptionsRouter(viewController: self)
    private var pageType: TeamToBeVisionOptionsModel.Types!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Init
    init(configure: Configurator<TeamToBeVisionOptionsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        interactor.viewDidLoad()
        tableView.registerDequeueable(TeamToBeVisionOptionTableViewCell.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .carbon)
        updateBottomNavigation(bottomNavigationLeftBarItems(), [])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem] {
        return [backNavigationItem()]
    }
}

// MARK: - TeamToBeVisionOptionsViewControllerInterface
extension TeamToBeVisionOptionsViewController: TeamToBeVisionOptionsViewControllerInterface {
    func setupView(type: TeamToBeVisionOptionsModel.Types, remainingDays: Int) {
        pageType = type
        ThemeView.level1.apply(view)
        baseHeaderView?.configure(title: type.pageTitle,
                                  subtitle: interactor.getTeamTBVPollRemainingDays(remainingDays))
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TeamToBeVisionOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getType.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TeamToBeVisionOptionTableViewCell = tableView.dequeueCell(for: indexPath)
        switch ActionType(rawValue: indexPath.row)! {
        case .rate:
            cell.configure(title: pageType.titleForItem(at: indexPath),
                           cta: pageType.ctaForItem(at: indexPath, isDisabled: interactor.userDidVote),
                           actionType: .rate,
                           buttonDisabled: interactor.userDidVote)
        case .end:
            let isDisabled = false
            cell.configure(title: pageType.titleForItem(at: indexPath),
                           cta: pageType.ctaForItem(at: indexPath, isDisabled: isDisabled),
                           actionType: .end,
                           buttonDisabled: isDisabled)
        }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

extension TeamToBeVisionOptionsViewController: TeamToBeVisionOptionsViewControllerDelegate {
    func showAlert() {
        let cancel = QOTAlertAction(title: interactor.alertCancelTitle)
        let end = QOTAlertAction(title: interactor.alertEndTitle) { [weak self] (_) in
        // TO DO: end rating or end poll
        }
        QOTAlert.show(title: pageType.alertTitle,
                      message: pageType.alertMessage.replacingOccurrences(of: "${daysCount}",
                                                                          with: String(interactor.daysLeft)),
                      bottomItems: [cancel, end])
    }
}
