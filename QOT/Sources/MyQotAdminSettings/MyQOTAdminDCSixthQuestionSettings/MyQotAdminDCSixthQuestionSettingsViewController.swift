//
//  MyQotAdminDCSixthQuestionSettingsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 16/12/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit
import qot_dal

final class MyQotAdminDCSixthQuestionSettingsViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?

    var interactor: MyQotAdminDCSixthQuestionSettingsInteractorInterface!
    var currentSetting: [Int]?
    var datasource: [[Int]] = [[0, 1, 2],
                               [0, 2, 1],
                               [1, 0, 2],
                               [1, 2, 0],
                               [2, 0, 1],
                               [2, 1, 0]]

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        MyQotAdminDCSixthQuestionSettingsViewController.getSixthQuestionPriority { [weak self] (setting) in
            self?.currentSetting = setting
            self?.tableView.reloadData()
        }
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeView.level2.apply(UIApplication.shared.statusBarView ?? UIView())
    }
}
    // MARK: - Private
private extension MyQotAdminDCSixthQuestionSettingsViewController {
    func setupTableView() {
        ThemeView.level2.apply(view)
        ThemeView.level2.apply(tableView)
        ThemeView.level2.apply(headerView)
        tableView.registerDequeueable(MyQotProfileOptionsTableViewCell.self)
        ThemeView.level2.apply(self.view)
        baseHeaderView?.configure(title: "DAILY CHECKIN 6TH QUESTION", subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView.headerView(with: .level2)
        tableView.reloadData()
    }
}
    // MARK: - TableView Delegate and Datasource

extension MyQotAdminDCSixthQuestionSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)
        let isSelected = datasource[indexPath.row] == currentSetting
        let checkMark = R.image.registration_checkmark()
        var title = ""
        switch indexPath.row {
        case 0:
            title = "TBV - SHPI - PEAK"
        case 1:
            title = "TBV - PEAK - SHPI"
        case 2:
            title = "SHPI - TBV - PEAK"
        case 3:
            title = "SHPI - PEAK - TBV"
        case 4:
            title = "PEAK - TBV - SHPI"
        default:
            title = "PEAK - SHPI - TBV"
        }

        cell.configure(title: title, subtitle: nil)
        cell.customAccessoryImageView.image = isSelected ? checkMark : nil

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        setSixthQuestionPriorities(datasource[indexPath.row]) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    public static func getSixthQuestionPriority(completion: @escaping ([Int]) -> Void) {
        SettingService.main.getSettingFor(key: SettingKey.DailyCheckInSixthQuestionWeight) { (setting, _, _) in
            if let json = setting?.textValue, let jsonData = json.data(using: .utf8) {
                do {
                    let weights = try JSONDecoder().decode(DailyCheckInSixthQuestionWeight.self, from: jsonData)
                    let weekday = (Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 1)
                    switch weekday {
                    case 2: completion(weights.monday ?? [0, 1, 2])
                    case 3: completion(weights.tuesday ?? [0, 1, 2])
                    case 4: completion(weights.wednesday ?? [0, 1, 2])
                    case 5: completion(weights.thursday ?? [0, 1, 2])
                    case 6: completion(weights.friday ?? [0, 1, 2])
                    case 7: completion(weights.saturday ?? [0, 1, 2])
                    default: completion(weights.sunday ?? [0, 1, 2])
                    }
                } catch {
                    completion([0, 1, 2])
                    print("failed to get DC 6th question settings")
                }
            }
        }
    }

    func setSixthQuestionPriorities(_ priorities: [Int], completion: @escaping () -> Void) {
        SettingService.main.getSettingFor(key: SettingKey.DailyCheckInSixthQuestionWeight) { (setting, _, _) in
            if let json = setting?.textValue, let jsonData = json.data(using: .utf8) {
                do {
                    var weights = try JSONDecoder().decode(DailyCheckInSixthQuestionWeight.self, from: jsonData)
                    let weekday = (Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 1)

                    switch weekday {
                    case 2: weights.monday = priorities
                    case 3: weights.tuesday = priorities
                    case 4: weights.wednesday = priorities
                    case 5: weights.thursday = priorities
                    case 6: weights.friday = priorities
                    case 7: weights.saturday = priorities
                    default: weights.sunday = priorities
                    }
                    do {
                        if var newSetting = setting {
                            let textValue = try JSONEncoder().encode(weights)
                            newSetting.textValue = String(data: textValue, encoding: .utf8)
                            SettingService.main.updateSetting(newSetting, false) { (_) in
                                completion()
                            }
                        }
                    } catch {
                        print("failed to encode DailyCheckInSixthQuestionWeight")
                    }
                } catch {
                    print("failed to get DC 6th question settings")
                }
            }
        }
    }
}

// MARK: - MyQotAdminDCSixthQuestionSettingsViewControllerInterface
extension MyQotAdminDCSixthQuestionSettingsViewController: MyQotAdminDCSixthQuestionSettingsViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
