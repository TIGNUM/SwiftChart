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
    func showPoll()
    func didTapRateOrVote()
}

final class TeamToBeVisionOptionsViewController: BaseViewController, ScreenZLevel2 {

    enum ActionType: Int {
        case rate = 0
        case end
    }

    // MARK: - Properties
    var interactor: TeamToBeVisionOptionsInteractorInterface!
    private lazy var router = TeamToBeVisionOptionsRouter(viewController: self)
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
    func setupView(type: TeamToBeVisionOptionsModel.Types, headerSubtitle: NSAttributedString) {
        pageType = type
        ThemeView.level1.apply(view)
        baseHeaderView?.configure(title: type.pageTitle, subtitle: headerSubtitle)
    }

    func reload() {
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
    func showPoll() {
        switch pageType {
        case .rating:
            if let teamTBVId = interactor.trackerPoll?.teamToBeVisionId {
                router.showRateScreen(with: teamTBVId,
                                      team: interactor.team,
                                      delegate: self)
            }
        case .voting:
            if let team = interactor.team {
                router.showTeamTBVGenerator(poll: interactor.toBeVisionPoll, team: team)
            }
        default:
            break
        }
    }

    func showAlert() {
        let cancel = QOTAlertAction(title: interactor.alertCancelTitle)
        let end = QOTAlertAction(title: interactor.alertEndTitle) { [weak self] _ in
            switch self?.pageType {
            case .rating:
                self?.interactor.endRating { [weak self] in
                    self?.didTapBackButton()
                }
            case .voting:
                self?.interactor.endPoll { [weak self] in
                    self?.didTapBackButton()
                }
            default: break
            }
        }
        let message = pageType.alertMessage.replacingOccurrences(of: "${daysCount}", with: String(interactor.daysLeft))
        QOTAlert.show(title: pageType.alertTitle,
                      message: message,
                      bottomItems: [cancel, end])
    }

    func didTapRateOrVote() {
        switch pageType {
        case .rating:
            interactor.getTeamToBeVision { [weak self] (teamTBV) in
                self?.router.showRateScreen(with: teamTBV?.remoteID ?? 0,
                                            team: self?.interactor.team,
                                            delegate: nil)
            }
        case .voting:
            router.showTBVGenerator()
        default: break
        }
    }
}
