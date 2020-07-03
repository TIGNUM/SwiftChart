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
    private var teamHeaderItems = [TeamHeader]()
    @IBOutlet weak var horizontalHeaderView: HorizontalHeaderView!
    @IBOutlet weak var horizontalHeaderHeight: NSLayoutConstraint!

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
        interactor!.viewDidLoad()
        tableView.registerDequeueable(TeamSettingsTableViewCell.self)
        tableView.registerDequeueable(TeamNameTableViewCell.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .carbon)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//           if let siriShortcutsVC  = segue.destination as? MyQotSiriShortcutsViewController {
//               MyQotSiriShortcutsConfigurator.configure(viewController: siriShortcutsVC)
//           } else if let activityTrackerVC = segue.destination as? MyQotSensorsViewController {
//               MyQotSensorsConfigurator.configure(viewController: activityTrackerVC)
//           } else if let syncedCalendarVC = segue.destination as? SyncedCalendarsViewController {
//               SyncedCalendarsConfigurator.configure(viewController: syncedCalendarVC)
//           }
       }
}

// MARK: - Actions
private extension MyXTeamSettingsViewController {
     @objc func confirmDeleteTapped(_ sender: Any) {
//        to do
    }

    @objc func cancelDeleteTapped(_ sender: Any) {
    }
//     to do
}

// MARK: - MyXTeamSettingsViewControllerInterface
extension MyXTeamSettingsViewController: MyXTeamSettingsViewControllerInterface {

    func setup(_ settings: MyXTeamSettingsModel) {
        ThemeView.level3.apply(view)
        settingsModel = settings
        baseHeaderView?.configure(title: interactor?.teamSettingsText, subtitle: nil)
        headerHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0
    }

    func updateTeamHeader(teamHeaderItems: [TeamHeader]) {
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = MyXTeamSettingsModel.Setting.teamSettings.at(index: indexPath.item) else {
            return UITableViewCell()
        }
        switch item {
        case .teamName:
            let cell: TeamNameTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: interactor!.getTeamName(), themeCell: .level3)
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
        if let item = MyXTeamSettingsModel.Setting.teamSettings.at(index: indexPath.item) {
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
                                           action: #selector(confirmDeleteTapped(_:)),
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
        router?.presentEditTeam(.edit, team: nil)
    }
}
