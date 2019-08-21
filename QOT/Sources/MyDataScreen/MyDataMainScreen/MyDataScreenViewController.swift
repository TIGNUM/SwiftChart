//
//  MyDataScreenViewController.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class MyDataScreenViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyDataScreenInteractorInterface?
    var router: MyDataScreenRouterInterface?
    @IBOutlet private weak var tableView: UITableView!
    private var myDataScreenModel: MyDataScreenModel?
    // MARK: - Init
    
    init(configure: Configurator<MyDataScreenViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let configurator = MyDataScreenConfigurator.make()
        configurator(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private
private extension MyDataScreenViewController {
    func setupTableView() {
        tableView.registerDequeueable(MyDataInfoTableViewCell.self)
    }
}

// MARK: - Actions
private extension MyDataScreenViewController {

}

// MARK: - MyDataScreenViewControllerInterface
extension MyDataScreenViewController: MyDataScreenViewControllerInterface {
    func setupView() {
        setupTableView()
    }
    
    func setup(for myDataSection: MyDataScreenModel) {
        myDataScreenModel = myDataSection
    }
}

extension MyDataScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let infoCell: MyDataInfoTableViewCell = tableView.dequeueCell(for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.carbon
            infoCell.selectedBackgroundView = backgroundView
            infoCell.backgroundColor = .carbonNew
            infoCell.configure(title: myDataScreenModel?.myDataItems[0].title, subtitle: myDataScreenModel?.myDataItems[0].subtitle)
            infoCell.delegate = self
            
            return infoCell
        case 1:
            let dailyImpactCell: MyDataInfoTableViewCell = tableView.dequeueCell(for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.carbon
            dailyImpactCell.selectedBackgroundView = backgroundView
            dailyImpactCell.backgroundColor = .carbonNew
            dailyImpactCell.configure(title: myDataScreenModel?.myDataItems[0].title, subtitle: myDataScreenModel?.myDataItems[0].subtitle)
            
            return dailyImpactCell
        case 2:
            let infoCell: MyDataInfoTableViewCell = tableView.dequeueCell(for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.carbon
            infoCell.selectedBackgroundView = backgroundView
            infoCell.backgroundColor = .carbonNew
            infoCell.configure(title: myDataScreenModel?.myDataItems[1].title, subtitle: myDataScreenModel?.myDataItems[1].subtitle)
            infoCell.delegate = self
            
            return infoCell
        case 3:
            let heatMapCell: MyDataInfoTableViewCell = tableView.dequeueCell(for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.carbon
            heatMapCell.selectedBackgroundView = backgroundView
            heatMapCell.backgroundColor = .carbonNew
            heatMapCell.configure(title: myDataScreenModel?.myDataItems[0].title, subtitle: myDataScreenModel?.myDataItems[0].subtitle)
            
            return heatMapCell
        default:
            return UITableViewCell.init()
        }
    }
}

extension MyDataScreenViewController: MyDataInfoTableViewCellDelegate {
    func didTapInfoButton() {
        
    }
}
