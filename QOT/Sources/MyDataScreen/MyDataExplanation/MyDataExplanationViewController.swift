//
//  MyDataExplanationViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataExplanationViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyDataExplanationInteractorInterface?
    var router: MyDataExplanationRouterInterface?
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    private var myDataExplanationModel: MyDataExplanationModel?

    // MARK: - Init
    init(configure: Configurator<MyDataExplanationViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let configurator = MyDataExplanationConfigurator.make()
        configurator(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - UITableView Delegate and Datasource
extension MyDataExplanationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataExplanationModel?.myDataExplanationItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyDataExplanationScreenTableViewCell = tableView.dequeueCell(for: indexPath)

        cell.configure(forExplanationItem: myDataExplanationModel?.myDataExplanationItems[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 80))
    }
}

// MARK: - Private
private extension MyDataExplanationViewController {
    func setupTableView() {
        tableView.registerDequeueable(MyDataExplanationScreenTableViewCell.self)
        tableView.separatorInset = .zero
        tableView.separatorColor = .sand30
    }
}

// MARK: - Actions
private extension MyDataExplanationViewController {

}

// MARK: - MyDataExplanationViewControllerInterface
extension MyDataExplanationViewController: MyDataExplanationViewControllerInterface {
    func setupView() {
        setupTableView()
    }

    func setup(for myDataExplanationSection: MyDataExplanationModel, myDataExplanationHeaderTitle: String) {
        myDataExplanationModel = myDataExplanationSection
        headerTitleLabel.text = myDataExplanationHeaderTitle.uppercased()
    }
}
