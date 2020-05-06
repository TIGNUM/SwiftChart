//
//  MyQotSupportViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotSupportViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var tableView: UITableView!
    var interactor: MyQotSupportInteractorInterface?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        interactor?.viewDidLoad()
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
        guard let myQotSupportDetails  = segue.destination as? MyQotSupportDetailsViewController,
              let category = sender as? ContentCategory else {
            return
        }
        MyQotSupportDetailsConfigurator.configure(viewController: myQotSupportDetails, category: category)
    }
}

extension MyQotSupportViewController: MyQotSupportViewControllerInterface {
    func setupView() {
        ThemeView.level3.apply(view)
        baseHeaderView?.configure(title: (interactor?.supportText ?? "").uppercased(), subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0
        setUpTableView()
    }

    func setUpTableView() {
        ThemeView.level3.apply(tableView)
        tableView.registerDequeueable(TitleSubtitleTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyQotSupportViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.itemCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        let subtitle = interactor?.subtitle(at: indexPath)
        cell.configure(title: interactor?.title(at: indexPath) ?? "", themeCell: .level3)
        cell.configure(subTitle: subtitle ?? "", isHidden: subtitle == "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = interactor?.trackingKeys(at: indexPath)
        trackUserEvent(.OPEN, valueType: key, action: .TAP)
        interactor?.handleSelection(for: indexPath)
    }
}
