//
//  MyLibraryCategoryListViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryCategoryListViewController: BaseViewController, ScreenZLevel2 {

    // MARK: - Properties

    var interactor: MyLibraryCategoryListInteractorInterface?
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!

    private var isFirstAppear = true

    // MARK: - Init

    init(configure: Configurator<MyLibraryCategoryListViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let configurator = MyLibraryCategoryListConfigurator.make(with: nil)
        configurator(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFirstAppear {
            interactor?.reload()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
        isFirstAppear = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        tableView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: BottomNavigationContainer.height, right: .zero)
        interactor?.viewDidLoad()
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = .zero
        pageTrack.pageKey = pageKey
        if let teamId = interactor?.teamId {
            pageTrack.associatedValueId = teamId
            pageTrack.associatedValueType = .TEAM
        }
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

// MARK: - Private

private extension MyLibraryCategoryListViewController {

}

// MARK: - Actions

private extension MyLibraryCategoryListViewController {

}

// MARK: - MyLibraryCategoryListViewControllerInterface

extension MyLibraryCategoryListViewController: MyLibraryCategoryListViewControllerInterface {
    func setupView() {
        ThemeView.level2.apply(view)
        baseHeaderView?.configure(title: interactor?.titleText, subtitle: nil)
        ThemeText.myLibraryTitle.apply(interactor?.titleText, to: baseHeaderView?.titleLabel)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.view.frame.size.width) ?? .zero
    }

    func update() {
        tableView.reloadData()
    }
}

extension MyLibraryCategoryListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.categoryItems.count ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell: MyLibraryCategoryTableViewCell = tableView.dequeueCell(for: indexPath)
        guard interactor?.categoryItems.count ?? .zero > .zero else {
            categoryCell.configure(withModel: nil)
            return categoryCell
        }
        categoryCell.configure(withModel: interactor?.categoryItems[indexPath.row])
        return categoryCell
    }
}

extension MyLibraryCategoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if interactor?.categoryItems.count ?? .zero > .zero {
            interactor?.handleSelectedItem(at: indexPath.row)
        }
    }
}
