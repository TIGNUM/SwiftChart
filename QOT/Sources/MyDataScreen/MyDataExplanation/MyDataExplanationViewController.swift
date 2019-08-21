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
    @IBOutlet private weak var tableView: UITableView!
    
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
}

// MARK: - Private
private extension MyDataExplanationViewController {

}

// MARK: - Actions
private extension MyDataExplanationViewController {

}

// MARK: - MyDataExplanationViewControllerInterface
extension MyDataExplanationViewController: MyDataExplanationViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
