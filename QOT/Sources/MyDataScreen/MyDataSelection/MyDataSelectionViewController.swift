//
//  MyDataSelectionViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataSelectionViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyDataSelectionInteractorInterface?
    var router: MyDataSelectionRouterInterface?
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Init
    init(configure: Configurator<MyDataSelectionViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let configurator = MyDataSelectionConfigurator.make()
        configurator(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - UITableView Delegate and Datasource
extension MyDataSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
}

// MARK: - Private
private extension MyDataSelectionViewController {

}

// MARK: - Actions
private extension MyDataSelectionViewController {

}

// MARK: - MyDataSelectionViewControllerInterface
extension MyDataSelectionViewController: MyDataSelectionViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
