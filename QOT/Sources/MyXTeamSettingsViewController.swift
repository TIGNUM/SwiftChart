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

final class MyXTeamSettingsViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyXTeamSettingsInteractorInterface!
    var router: MyXTeamSettingsRouterInterface?
    @IBOutlet private weak var headerView: UIView!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var tableView: UITableView!
    private var settingsModel: MyXTeamSettingsModel!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    private var teamHeaderItems = [TeamHeader.Item]()
    @IBOutlet private weak var horizontalHeaderView: HorizontalHeaderView!
    @IBOutlet private weak var horizontalHeaderHeight: NSLayoutConstraint!

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
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        ThemeView.level3.apply(tableView)
        interactor.viewDidLoad()
        tableView.registerDequeueable(TeamSettingsTableViewCell.self)
        tableView.registerDequeueable(TeamNameTableViewCell.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(colorMode: ColorMode.dark)
        setStatusBar(color: ThemeView.level1.color)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - Actions
private extension MyXTeamSettingsViewController {
     @objc func confirmDeleteTapped(_ sender: Any) {
        guard let selectedTeam = interactor.selectedTeam else { return }
        interactor.deleteTeam(team: selectedTeam)
    }

    @objc func confirmLeaveTapped(_ sender: Any) {
        guard let selectedTeam = interactor.selectedTeam else { return }
        interactor.leaveTeam(team: selectedTeam)
    }

    @objc func cancelDeleteTapped(_ sender: Any) {
    }
}

// MARK: - MyXTeamSettingsViewControllerInterface
extension MyXTeamSettingsViewController: MyXTeamSettingsViewControllerInterface {

    func setup(_ settings: MyXTeamSettingsModel) {
        ThemeView.level3.apply(view)
        settingsModel = settings
        baseHeaderView?.configure(title: interactor?.teamSettingsText, subtitle: nil)
        headerHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0
    }

    func updateTeamHeader(teamHeaderItems: [TeamHeader.Item]) {
        self.teamHeaderItems = teamHeaderItems
        teamHeaderItems.isEmpty ? horizontalHeaderHeight.constant = 0 : horizontalHeaderView.configure(headerItems: teamHeaderItems)
    }

    func updateView() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyXTeamSettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return settingsModel.teamSettingsCount
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = MyXTeamSettingsModel.Setting.allCases.at(index: indexPath.item) else {
            fatalError("MyXTeamSettings Item does not exist at indexPath: \(indexPath.item)")
        }
        switch item {
        case .teamName:
            let cell: TeamNameTableViewCell = tableView.dequeueCell(for: indexPath)
            interactor.getAvailableColors { [weak self] (teamColors) in
                guard let strongSelf = self else { return }
                cell.configure(teamId: strongSelf.interactor.getTeamId(),
                               teamColors: teamColors,
                               selectedColor: strongSelf.interactor.getTeamColor(),
                               title: strongSelf.interactor.getTeamName())
            }
            cell.delegate = self
            return cell
        case .teamMembers:
            let cell: TeamSettingsTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: settingsModel.titleForItem(at: indexPath), themeCell: .level3)
            let subtitle = settingsModel.subtitleForItem(at: indexPath)
            cell.configure(subTitle: subtitle, isHidden: subtitle == "")
            cell.accessoryView = UIImageView(image: R.image.ic_disclosure_accent())
            return cell
        default:
            let cell: TeamSettingsTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: settingsModel.titleForItem(at: indexPath), themeCell: .level3)
            let subtitle = settingsModel.subtitleForItem(at: indexPath)
            cell.configure(subTitle: subtitle, isHidden: subtitle == "")
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = MyXTeamSettingsModel.Setting.allCases.at(index: indexPath.item) {
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
            let deleteMessage = AppTextService.get(.settings_team_settings_confirmation_delete) + " " + (interactor.selectedTeam?.name ?? "")
            let leaveMessage = AppTextService.get(.settings_team_settings_confirmation_leave) + " " + (interactor.selectedTeam?.name ?? "")
            switch item {
            case .deleteTeam:
                QOTAlert.show(title: deleteTitle, message: deleteMessage, bottomItems: [cancel, deleteTeam])
            case .leaveTeam:
                QOTAlert.show(title: leaveTitle, message: leaveMessage, bottomItems: [cancel, leaveTeam])
            case .teamMembers:
//                to do
                print("go to team members")
            default:
                break
            }
        }
    }
}
// MARK: - MyXTeamSettingsViewControllerDelegate
extension MyXTeamSettingsViewController: MyXTeamSettingsViewControllerDelegate {

    func presentEditTeam() {
        router?.presentEditTeam(.edit, team: interactor.selectedTeam)
    }
}
