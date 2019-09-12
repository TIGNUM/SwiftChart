//
//  MyLibraryCategoryListViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyLibraryCategoryListViewController: UIViewController, ScreenZLevel2 {

    // MARK: - Properties

    var interactor: MyLibraryCategoryListInteractorInterface?
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        interactor?.viewDidLoad()
        self.showLoadingSkeleton(with: [.oneLineHeading, .myQOTCell, .myQOTCell, .myQOTCell, .myQOTCell, .myQOTCell])
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
    func update() {
        ThemeView.level2.apply(view)
        tableView.reloadData()
        self.removeLoadingSkeleton()
    }

}

extension MyLibraryCategoryListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.categoryItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell: MyLibraryCategoryTableViewCell = tableView.dequeueCell(for: indexPath)
        let data = interactor?.categoryItems[indexPath.row]
        categoryCell.categoryName.text = data?.title
        categoryCell.iconView.image = UIImage(named: data?.iconName ?? "")
        categoryCell.infoText.text = data?.infoText()
        return categoryCell
    }
}

extension MyLibraryCategoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor?.handleSelectedItem(at: indexPath.row)
    }
}
