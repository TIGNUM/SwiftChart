//
//  TeamToBeVisionOptionsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol TeamToBeVisionOptionsViewControllerDelegate: class {
    func showAlert()
    func didTapRateOrVote()
}

final class TeamToBeVisionOptionsViewController: UIViewController {

    enum actionType: Int {
        case rate = 0
        case end
    }

    // MARK: - Properties
    var interactor: TeamToBeVisionOptionsInteractorInterface!
    private lazy var router: TeamToBeVisionOptionsRouterInterface = TeamToBeVisionOptionsRouter(viewController: self)
    @IBOutlet private weak var headerView: UIView!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var tableView: UITableView!
    private var pageType: TeamToBeVisionOptionsModel.Types!
//   TODO: pass in hasVoted argument if user has voted or rated
    private var hasVoted: Bool = false

    // MARK: - Init
    init(configure: Configurator<TeamToBeVisionOptionsViewController>) {
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
        interactor.viewDidLoad()
        tableView.registerDequeueable(TeamToBeVisionOptionTableViewCell.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBottomNavigation([dismissNavigationItem(action: #selector(dismissAction))], [])
    }

    @objc private func dismissAction() {
        dismiss(animated: true)
    }
}

// MARK: - TeamToBeVisionOptionsViewControllerInterface
extension TeamToBeVisionOptionsViewController: TeamToBeVisionOptionsViewControllerInterface {

    func setupView(type: TeamToBeVisionOptionsModel.Types, remainingDays: Int) {
        pageType = type
        ThemeView.level1.apply(view)
        baseHeaderView?.configure(title: type.pageTitle, subtitle: createSubtitle(remainingDays))
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TeamToBeVisionOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getType.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TeamToBeVisionOptionTableViewCell = tableView.dequeueCell(for: indexPath)
        switch indexPath.row {
        case actionType.rate.rawValue:
            cell.configure(title: pageType.titleForItem(at: indexPath),
                           cta: pageType.ctaForItem(at: indexPath, isDisabled: hasVoted),
                           actionTag: actionType.rate.rawValue,
                           buttonDisabled: hasVoted)
        case actionType.end.rawValue:
            let isDisabled = false
            cell.configure(title: pageType.titleForItem(at: indexPath),
                           cta: pageType.ctaForItem(at: indexPath, isDisabled: isDisabled),
                           actionTag: actionType.end.rawValue,
                           buttonDisabled: isDisabled)
        default:
            break
        }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

// MARK: Private
private extension TeamToBeVisionOptionsViewController {
    func createSubtitle(_ remainingDays: Int) -> NSAttributedString {
        let sandAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextRegular(ofSize: 16), .foregroundColor: UIColor.sand70]
        let redAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextRegular(ofSize: 16), .foregroundColor: UIColor.redOrange]
        let string = NSMutableAttributedString(string: AppTextService.get(.my_x_team_tbv_options_ends), attributes: sandAttributes)
        switch remainingDays {
        case 0:
            let today = NSMutableAttributedString(string: " " + AppTextService.get(.my_x_team_tbv_options_today), attributes: redAttributes)
            string.append(today)
            return string
        case 1:
            let tomorrow = NSMutableAttributedString(string: " " + AppTextService.get(.my_x_team_tbv_options_tomorrow), attributes: redAttributes)
            string.append(tomorrow)
            return string
        default:
            let daysString = NSMutableAttributedString(string: " " + AppTextService.get(.my_x_team_tbv_options_days).replacingOccurrences(of: "${days}", with: String(remainingDays)), attributes: redAttributes)
            string.append(daysString)
            return string
        }
    }
}

extension TeamToBeVisionOptionsViewController: TeamToBeVisionOptionsViewControllerDelegate {

    func showAlert() {
        let cancel = QOTAlertAction(title: AppTextService.get(.my_x_team_tbv_options_alert_leftButton))
        let end = QOTAlertAction(title: AppTextService.get(.my_x_team_tbv_options_alert_rightButton)) {[weak self] (_) in
            switch self?.pageType {
            case .rating:
                self?.didEndRating()
            case .voting:
//                TODO: End voting
                break
            default: break
            }
        }
        QOTAlert.show(title: pageType.alertTitle, message: pageType.alertMessage.replacingOccurrences(of: "${daysCount}", with: String(interactor.daysLeft)), bottomItems: [cancel, end])
    }

    func didTapRateOrVote() {
        switch pageType {
        case .rating:
            interactor.showRateScreen()
        case .voting:
//            TODO: show Vote Screen
            break
        default: break
        }
    }

    func didEndRating() {
        interactor.endRating()
    }
}

extension TeamToBeVisionOptionsViewController: MyToBeVisionRateViewControllerProtocol {
    func doneAction() {

    }
}
