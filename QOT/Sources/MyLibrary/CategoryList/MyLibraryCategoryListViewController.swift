//
//  MyLibraryCategoryListViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyLibraryCategoryListViewController: BaseViewController, ScreenZLevel2 {

    // MARK: - Properties

    var interactor: MyLibraryCategoryListInteractorInterface?
    var baseHeaderview: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Init

    init(configure: Configurator<MyLibraryCategoryListViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let configurator = MyLibraryCategoryListConfigurator.make()
        configurator(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderview?.addTo(superview: headerView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        interactor?.viewDidLoad()
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
        baseHeaderview?.configure(title: interactor?.titleText, subtitle: nil)
        ThemeText.myLibraryTitle.apply(interactor?.titleText, to: baseHeaderview?.titleLabel)
        headerViewHeightConstraint.constant = baseHeaderview?.calculateHeight(for: self.view.frame.size.width) ?? 0
    }

    func update() {
        tableView.reloadData()
    }
}

extension MyLibraryCategoryListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.categoryItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell: MyLibraryCategoryTableViewCell = tableView.dequeueCell(for: indexPath)
        guard interactor?.categoryItems.count ?? 0 > 0 else {
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
        if interactor?.categoryItems.count ?? 0 > 0 {
            interactor?.handleSelectedItem(at: indexPath.row)
        }
    }
}
