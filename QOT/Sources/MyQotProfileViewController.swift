//
//  MyQotViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(MyQotNavigationController.classForCoder())
}

final class MyQotProfileViewController: AbstractLevelOneViewConroller {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var bottomNavigationView: BottomNavigationBarView!

    private var profile: UserProfileModel?
    var interactor: MyQotProfileInteractorInterface?
    weak var delegate: CoachCollectionViewControllerDelegate?
    var menuItems: [MyQotProfileModel.TableViewPresentationData] {
        return interactor?.menuItems ?? []
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .carbonDark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let accountSettingsVC  = segue.destination as? MyQotAccountSettingsViewController {
            MyQotAccountSettingsConfigurator.configure(viewController: accountSettingsVC)
        } else if let appSettingsVC  = segue.destination as? MyQotAppSettingsViewController {
            MyQotAppSettingsConfigurator.configure(viewController: appSettingsVC)
        } else if let supportVC = segue.destination as? MyQotSupportViewController {
            MyQotSupportConfigurator.configure(viewController: supportVC)
        }else if let aboutTignum = segue.destination as? MyQotAboutUsViewController {
            MyQotAboutUsConfigurator.configure(viewController: aboutTignum)
        }
    }
}

// MARK: - Actions

private extension MyQotProfileViewController {
    func setupTableView() {
        tableView.registerDequeueable(MyQotProfileOptionsTableViewCell.self)
        tableView.registerDequeueable(MyQotProfileHeaderView.self)
    }
}

// MARK: - MyQotViewControllerInterface

extension MyQotProfileViewController: MyQotProfileViewControllerInterface {
    
    func setup(profile: UserProfileModel) {
        self.profile = profile
    }

    func setupView() {
        bottomNavigationView.delegate = self
        headerLabel.text = interactor?.myProfileText
        setupTableView()
    }
}

// MARK:- TableView Delegate and Datasource

extension MyQotProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(menuItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = menuItems[indexPath.row].headingKey
        trackUserEvent(.OPEN, valueType: key, action: .TAP)
        interactor?.presentController(for: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 104
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: MyQotProfileHeaderView = tableView.dequeueHeaderFooter()
        headerView.configure(data: MyQotProfileModel.HeaderViewModel(user: interactor?.userProfile, memberSinceTitle: interactor?.memberSinceText))
        return headerView
    }
}

extension MyQotProfileViewController: BottomNavigationBarViewProtocol {
    func willNavigateBack() {
        trackUserEvent(.CLOSE, action: .TAP)
    }
}
