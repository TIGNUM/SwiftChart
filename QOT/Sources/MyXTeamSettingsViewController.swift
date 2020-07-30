//
//  MyXTeamSettingsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol MyXTeamSettingsViewControllerDelegate: class {
    func presentEditTeam()
}

final class MyXTeamSettingsViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var horizontalHeaderView: HorizontalHeaderView!
    @IBOutlet private weak var horizontalHeaderHeight: NSLayoutConstraint!
    var interactor: MyXTeamSettingsInteractorInterface!
    var router: MyXTeamSettingsRouterInterface?

    // MARK: - Init
    init(configure: Configurator<MyXTeamSettingsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

   required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .carbon)
        updateBottomNavigation([backNavigationItem()], [])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.viewDidAppear()
        trackPage()
    }
}

// MARK: - Actions
private extension MyXTeamSettingsViewController {
    @objc func confirmDeleteTapped(_ sender: Any) {
        guard let selectedTeam = interactor.getSelectedItem else { return }
        trackUserEvent(.DELETE_TEAM, stringValue: selectedTeam.teamId, valueType: .TEAM, action: .TAP)
        interactor.deleteTeam(teamItem: selectedTeam)
    }

    @objc func confirmLeaveTapped(_ sender: Any) {
        guard let selectedTeam = interactor.getSelectedItem else { return }
        trackUserEvent(.LEAVE_TEAM, stringValue: selectedTeam.teamId, valueType: .TEAM, action: .TAP)
        interactor.leaveTeam(teamItem: selectedTeam)
    }

    @objc func cancelDeleteTapped(_ sender: Any) {
        trackUserEvent(.CANCEL, action: .TAP)
    }

    func backToTeamSettings() -> UIBarButtonItem {
         return backNavigationItem()
    }
}

// MARK: - MyXTeamSettingsViewControllerInterface
extension MyXTeamSettingsViewController: MyXTeamSettingsViewControllerInterface {
    func setup() {
        let baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        ThemeView.level3.apply(tableView)
        tableView.registerDequeueable(TeamSettingsTableViewCell.self)
        tableView.registerDequeueable(TeamNameTableViewCell.self)
        ThemeView.level3.apply(view)
        baseHeaderView?.configure(title: interactor?.teamSettingsText, subtitle: nil)
        headerHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0
    }

    func updateView() {
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        tableView.endUpdates()
    }

    func updateTeamHeader(teamHeaderItems: [Team.Item]) {
        if teamHeaderItems.isEmpty {
            horizontalHeaderHeight.constant = 0
        } else {
            horizontalHeaderHeight.constant = 60
            horizontalHeaderView.configure(headerItems: teamHeaderItems, canDeselect: false)
        }
    }

    func dismiss() {
        router?.dismiss()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyXTeamSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.rowCount
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = interactor.getSettingItems().at(index: indexPath.row)
        switch item {
        case .teamName:
            let cell: TeamNameTableViewCell = tableView.dequeueCell(for: indexPath)
            interactor.getAvailableColors { [weak self] (teamColors) in
                guard let strongSelf = self else { return }
                cell.configure(teamId: strongSelf.interactor.getTeamId(),
                               teamColors: teamColors,
                               selectedColor: strongSelf.interactor.getTeamColor(),
                               title: strongSelf.interactor.getTeamName())
                cell.selectionStyle = .none
            }
            cell.delegate = self
            return cell
        case .teamMembers:
            let cell: TeamSettingsTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: interactor.getTitleForItem(at: indexPath), themeCell: .level3)
            let subtitle = interactor.getSubtitleForItem(at: indexPath)
            cell.configure(subTitle: subtitle, isHidden: subtitle == "")
            cell.accessoryView = UIImageView(image: R.image.ic_disclosure_accent())
            return cell
        default:
            let cell: TeamSettingsTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: interactor.getTitleForItem(at: indexPath), themeCell: .level3)
            let subtitle = interactor.getSubtitleForItem(at: indexPath)
            cell.configure(subTitle: subtitle, isHidden: subtitle == "")
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = interactor.getSettingItem(at: indexPath)
        let cancel = QOTAlertAction(title: AppTextService.get(.generic_view_button_cancel),
                                    target: self,
                                    action: #selector(cancelDeleteTapped(_:)),
                                    handler: nil)
        let deleteTeam = QOTAlertAction(title: AppTextService.get(.settings_team_settings_delete_team),
                                        target: self,
                                        action: #selector(confirmDeleteTapped(_:)),
                                        handler: nil)
        let leaveTeam = QOTAlertAction(title: AppTextService.get(.settings_team_settings_leave_team),
                                       target: self,
                                       action: #selector(confirmLeaveTapped(_:)),
                                       handler: nil)
        let deleteTitle = AppTextService.get(.settings_team_settings_delete_team).uppercased()
        let leaveTitle = AppTextService.get(.settings_team_settings_leave_team).uppercased()
        let deleteMessage = AppTextService.get(.settings_team_settings_confirmation_delete)
        let leaveMessage = AppTextService.get(.settings_team_settings_confirmation_leave)
        switch item {
        case .deleteTeam:
            QOTAlert.show(title: deleteTitle, message: deleteMessage, bottomItems: [cancel, deleteTeam])
        case .leaveTeam:
            QOTAlert.show(title: leaveTitle, message: leaveMessage, bottomItems: [cancel, leaveTeam])
        case .teamMembers:
            router?.presentTeamMembers(selectedTeamItem: interactor.getSelectedItem, teamItems: interactor.getTeamItems)
        default:
            break
        }
    }
}
// MARK: - MyXTeamSettingsViewControllerDelegate
extension MyXTeamSettingsViewController: MyXTeamSettingsViewControllerDelegate {
    func presentEditTeam() {
        router?.presentEditTeam(.edit, team: interactor.getSelectedItem?.qdmTeam)
    }
}
