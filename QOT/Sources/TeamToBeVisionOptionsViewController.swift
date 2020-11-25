//
//  TeamToBeVisionOptionsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

protocol TeamAdminDelegate: class {
    func showAlert()
    func showPoll()
}

final class TeamToBeVisionOptionsViewController: BaseViewController, ScreenZLevel2 {

    // MARK: - Properties
    var interactor: TeamToBeVisionOptionsInteractorInterface!
    private lazy var router = TeamToBeVisionOptionsRouter(viewController: self)
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
        tableView.registerDequeueable(TeamToBeVisionOptionTableViewCell.self)
        interactor.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.viewWillAppear()
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
    func setupView(title: String, headerSubtitle: NSAttributedString) {
        ThemeView.level1.apply(view)
        let baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        baseHeaderView?.configure(title: title, subtitle: headerSubtitle)
    }

    func reload() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

extension TeamToBeVisionOptionsViewController: TBVRateDelegate {
    func doneAction() {

    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TeamToBeVisionOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getType.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = interactor.getType
        let actionType = TeamAdmin.ActionType(rawValue: indexPath.row) ?? .rate
        let isDisabled = actionType == .end ? false : (interactor.userDidVote == true)
        let cell: TeamToBeVisionOptionTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: type.titleForItem(at: indexPath),
                       cta: type.ctaForItem(at: indexPath, isDisabled: isDisabled),
                       actionType: actionType,
                       buttonDisabled: isDisabled)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

extension TeamToBeVisionOptionsViewController: TeamAdminDelegate {
    func showPoll() {
        switch interactor.getType {
        case .rating:
            router.showRateScreen(trackerPoll: interactor.trackerPoll,
                                  team: interactor.team,
                                  showBanner: interactor.showBanner,
                                  delegate: self)
        case .voting:
            if let team = interactor.team {
                router.showTeamTBVGenerator(poll: interactor.toBeVisionPoll,
                                            team: team,
                                            showBanner: interactor.showBanner)
            }
        }
    }

    func showAlert() {
        let cancel = QOTAlertAction(title: interactor.alertCancelTitle)
        let hasRatings = interactor.trackerPoll?.qotTeamToBeVisionTrackers?.first?.qotTeamToBeVisionTrackerRatings?.isEmpty == false
        let end = QOTAlertAction(title: interactor.alertEndTitle) { [weak self] _ in
            switch self?.interactor.getType {
            case .rating:
                self?.interactor.endRating { [weak self] in
                    self?.navigationController?.popViewController {
                        guard hasRatings == true else { return }
                        self?.router.showTracker(for: self?.interactor.team)
                    }
                }
            case .voting:
                self?.interactor.endPoll { [weak self] in
                    self?.didTapBackButton()
                }
            default: break
            }
        }

        let message = interactor.getType.alertMessage.replacingOccurrences(of: "${daysCount}",
                                                                           with: String(interactor.daysLeft))
        QOTAlert.show(title: interactor.getType.alertTitle,
                      message: message,
                      bottomItems: [cancel, end])
    }
}
